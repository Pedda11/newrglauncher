import 'dart:io';

import '../../../../widgets/paths.dart';

class Log {
  static File _file() => File('${Paths.updatesDir()}\\logs\\launcher.log');

  static Future<void> i(String msg) async {
    final file = _file();

    /// Ensure parent directory exists before writing.
    await file.parent.create(recursive: true);

    final line = '${DateTime.now().toIso8601String()} /// $msg\n';
    await file.writeAsString(line, mode: FileMode.append, flush: true);
  }

  static Future<void> e(String msg) async {
    final file = _file();

    /// Ensure parent directory exists before writing.
    await file.parent.create(recursive: true);

    final line = '${DateTime.now().toIso8601String()} /// Fatal Error - $msg\n';
    await file.writeAsString(line, mode: FileMode.append, flush: true);
  }
}
