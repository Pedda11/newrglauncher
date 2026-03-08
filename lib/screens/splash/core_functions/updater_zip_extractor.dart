import 'dart:io';
import 'package:archive/archive.dart';

class UpdaterZipExtractor {
  static String get _installRoot {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null || localAppData.isEmpty) {
      throw StateError('LOCALAPPDATA not set');
    }

    return '$localAppData\\PeddaLauncher';
  }

  static String get targetDir => '$_installRoot\\updates\\updater_new';

  static Future<void> extractZip({
    required String zipPath,
  }) async {
    final target = Directory(targetDir);

    if (await target.exists()) {
      await target.delete(recursive: true);
    }
    await target.create(recursive: true);

    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final outPath = '${target.path}\\${file.name}';

      if (file.isFile) {
        final outFile = File(outPath);
        await outFile.parent.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>, flush: true);
      } else {
        await Directory(outPath).create(recursive: true);
      }
    }
  }
}
