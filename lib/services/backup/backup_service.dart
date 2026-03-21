import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

class BackupProgressData {
  final int processedFiles;
  final int totalFiles;
  final String? currentFilePath;

  const BackupProgressData({
    required this.processedFiles,
    required this.totalFiles,
    this.currentFilePath,
  });

  double get progress => totalFiles == 0 ? 0 : processedFiles / totalFiles;
}

typedef BackupProgressCallback = void Function(BackupProgressData progress);

class BackupService {
  static const int maxBackups = 14;

  Future<File?> createBackup({
    required String sourceFolderPath,
    required String backupFolderPath,
    BackupProgressCallback? onProgress,
  }) async {
    final sourceDir = Directory(sourceFolderPath);
    final backupDir = Directory(backupFolderPath);

    if (!await sourceDir.exists()) {
      throw FileSystemException(
        'Source folder does not exist',
        sourceFolderPath,
      );
    }

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    if (await _hasBackupForToday(backupDir)) {
      return null;
    }

    await _enforceBackupLimit(backupDir);

    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    final exitPort = ReceivePort();

    Isolate? isolate;

    try {
      isolate = await Isolate.spawn<_BackupIsolateRequest>(
        _backupIsolateEntry,
        _BackupIsolateRequest(
          sendPort: receivePort.sendPort,
          sourceFolderPath: sourceFolderPath,
          backupFolderPath: backupFolderPath,
        ),
        onError: errorPort.sendPort,
        onExit: exitPort.sendPort,
      );

      final completer = Completer<File>();

      late final StreamSubscription receiveSub;
      late final StreamSubscription errorSub;
      late final StreamSubscription exitSub;

      receiveSub = receivePort.listen((message) {
        if (message is Map) {
          final type = message['type'];

          if (type == 'progress') {
            onProgress?.call(
              BackupProgressData(
                processedFiles: message['processedFiles'] as int,
                totalFiles: message['totalFiles'] as int,
                currentFilePath: message['currentFilePath'] as String?,
              ),
            );
            return;
          }

          if (type == 'done') {
            final filePath = message['zipFilePath'] as String;
            completer.complete(File(filePath));
            return;
          }

          if (type == 'error') {
            final error =
                message['error'] as String? ?? 'Unknown isolate error';
            if (!completer.isCompleted) {
              completer.completeError(Exception(error));
            }
          }
        }
      });

      errorSub = errorPort.listen((message) {
        if (!completer.isCompleted) {
          completer.completeError(
            Exception('Backup isolate crashed: $message'),
          );
        }
      });

      exitSub = exitPort.listen((_) {});

      final file = await completer.future;

      await receiveSub.cancel();
      await errorSub.cancel();
      await exitSub.cancel();

      receivePort.close();
      errorPort.close();
      exitPort.close();

      isolate.kill(priority: Isolate.immediate);

      return file;
    } catch (e) {
      receivePort.close();
      errorPort.close();
      exitPort.close();
      isolate?.kill(priority: Isolate.immediate);
      rethrow;
    }
  }

  Future<void> _enforceBackupLimit(Directory backupDir) async {
    final entities = await backupDir.list().toList();

    final backupFiles = entities
        .whereType<File>()
        .where((file) => p.extension(file.path).toLowerCase() == '.zip')
        .toList();

    if (backupFiles.length < maxBackups) {
      return;
    }

    final filesWithStats = <({File file, DateTime modified})>[];

    for (final file in backupFiles) {
      final stat = await file.stat();
      filesWithStats.add((file: file, modified: stat.modified));
    }

    filesWithStats.sort((a, b) => a.modified.compareTo(b.modified));

    await filesWithStats.first.file.delete();
  }
}

class _BackupIsolateRequest {
  final SendPort sendPort;
  final String sourceFolderPath;
  final String backupFolderPath;

  const _BackupIsolateRequest({
    required this.sendPort,
    required this.sourceFolderPath,
    required this.backupFolderPath,
  });
}

Future<void> _backupIsolateEntry(_BackupIsolateRequest request) async {
  try {
    final sourceDir = Directory(request.sourceFolderPath);

    final files = <File>[];
    await _collectFiles(
      currentDir: sourceDir,
      files: files,
    );

    request.sendPort.send({
      'type': 'progress',
      'processedFiles': 0,
      'totalFiles': files.length,
      'currentFilePath': null,
    });

    final archive = Archive();
    var processedFiles = 0;

    for (final file in files) {
      final relativePath = p.relative(file.path, from: sourceDir.path);
      final bytes = await file.readAsBytes();

      archive.addFile(
        ArchiveFile(relativePath, bytes.length, bytes),
      );

      processedFiles++;

      request.sendPort.send({
        'type': 'progress',
        'processedFiles': processedFiles,
        'totalFiles': files.length,
        'currentFilePath': file.path,
      });
    }

    request.sendPort.send({'type': 'finalizing'});

    final zipData = ZipEncoder().encode(archive);

    if (zipData == null) {
      throw FileSystemException('Could not encode backup zip');
    }

    final timestamp = _buildTimestamp(DateTime.now());
    final zipFileName = '${timestamp}_WTF_backup.zip';
    final zipFilePath = p.join(request.backupFolderPath, zipFileName);

    final zipFile = File(zipFilePath);
    await zipFile.writeAsBytes(Uint8List.fromList(zipData), flush: true);

    request.sendPort.send({
      'type': 'done',
      'zipFilePath': zipFilePath,
    });
  } catch (e, st) {
    request.sendPort.send({
      'type': 'error',
      'error': '$e\n$st',
    });
  }
}

Future<void> _collectFiles({
  required Directory currentDir,
  required List<File> files,
}) async {
  await for (final entity
      in currentDir.list(recursive: false, followLinks: false)) {
    if (entity is File) {
      files.add(entity);
    } else if (entity is Directory) {
      await _collectFiles(
        currentDir: entity,
        files: files,
      );
    }
  }
}

String _buildTimestamp(DateTime dateTime) {
  final year = dateTime.year.toString().padLeft(4, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final second = dateTime.second.toString().padLeft(2, '0');

  return '$year-$month-${day}_$hour-$minute-$second';
}

Future<bool> _hasBackupForToday(Directory backupDir) async {
  final todayPrefix = _buildDatePrefix(DateTime.now());

  await for (final entity in backupDir.list(followLinks: false)) {
    if (entity is! File) {
      continue;
    }

    final fileName = p.basename(entity.path).toLowerCase();

    if (p.extension(fileName) != '.zip') {
      continue;
    }

    if (fileName.startsWith(todayPrefix) &&
        fileName.endsWith('_wtf_backup.zip')) {
      return true;
    }
  }

  return false;
}

String _buildDatePrefix(DateTime dateTime) {
  final year = dateTime.year.toString().padLeft(4, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');

  return '$year-$month-$day';
}
