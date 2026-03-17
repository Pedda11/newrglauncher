import 'dart:io';

import '../widgets/paths.dart';

class LogReader {
  static File _file() => File('${Paths.updatesDir()}\\logs\\launcher.log');

  /// Returns the last [lineCount] lines of the launcher log.
  static Future<List<String>> readLastLines(int lineCount) async {
    final file = _file();

    if (!await file.exists()) {
      return [];
    }

    final content = await file.readAsString();

    final lines = content.split('\n');

    /// Remove empty trailing lines
    final cleaned = lines.where((l) => l.trim().isNotEmpty).toList();

    if (cleaned.length <= lineCount) {
      return cleaned;
    }

    return cleaned.sublist(cleaned.length - lineCount);
  }
}
