import 'dart:io';

import '../../../../widgets/paths.dart';

class Log {
  static File _file() => File('${Paths.updatesDir()}\\logs\\launcher.log');

  static String _sanitize(String msg) {
    final regex = RegExp(r'Users\\([^\\]+)', caseSensitive: false);

    return msg.replaceAllMapped(regex, (match) {
      return 'Users\\\\####';
    });
  }

  static Future<void> i(String msg) async {
    final sanitizedMsg = _sanitize(msg);

    final file = _file();

    /// Ensure parent directory exists before writing.
    await file.parent.create(recursive: true);

    final line = '${DateTime.now().toIso8601String()} /// $sanitizedMsg\n';
    await file.writeAsString(line, mode: FileMode.append, flush: true);
  }
}
