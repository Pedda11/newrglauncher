import 'dart:io';

import '../../../../widgets/paths.dart';

class Log {
  static const int _maxLogFiles = 20;

  static File? _currentLogFile;

  static Future<void> init() async {
    final logsDir = Directory('${Paths.updatesDir()}\\logs');
    await logsDir.create(recursive: true);

    await _cleanupOldLogs(logsDir);

    final timestamp = _buildTimestamp(DateTime.now());
    _currentLogFile = File('${logsDir.path}\\launcher_$timestamp.log');

    /// /// Ensure file exists
    if (!await _currentLogFile!.exists()) {
      await _currentLogFile!.create(recursive: true);
    }
  }

  static String _sanitize(String msg) {
    final regex = RegExp(r'Users\\([^\\]+)', caseSensitive: false);

    return msg.replaceAllMapped(regex, (match) {
      return 'Users\\\\####';
    });
  }

  static Future<void> i(String msg) async {
    if (_currentLogFile == null) {
      await init();
    }

    final sanitizedMsg = _sanitize(msg);
    final line = '${DateTime.now().toIso8601String()} /// $sanitizedMsg\n';

    await _currentLogFile!.writeAsString(
      line,
      mode: FileMode.append,
      flush: true,
    );
  }

  static Future<void> _cleanupOldLogs(Directory logsDir) async {
    final entities = await logsDir.list().toList();

    final logFiles = entities
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.log'))
        .toList();

    if (logFiles.length < _maxLogFiles) {
      return;
    }

    final filesWithStats = <({File file, DateTime modified})>[];

    for (final file in logFiles) {
      final stat = await file.stat();
      filesWithStats.add((file: file, modified: stat.modified));
    }

    filesWithStats.sort((a, b) => a.modified.compareTo(b.modified));

    final filesToDelete = filesWithStats.length - _maxLogFiles + 1;

    for (var i = 0; i < filesToDelete; i++) {
      await filesWithStats[i].file.delete();
    }
  }

  static String _buildTimestamp(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');

    return '$year-$month-${day}_$hour-$minute-$second';
  }
}
