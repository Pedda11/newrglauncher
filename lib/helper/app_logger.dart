import 'dart:developer' as developer;

import '../enum/e_log_level.dart';


class AppLogger {

  static void _log(
      String message, {
        required String tag,
        required LogLevel level,
        Object? error,
        StackTrace? stackTrace,
      }) {
    final prefix = '[${level.name.toUpperCase()}] [$tag]';

    print('$prefix $message');

    developer.log(
      message,
      name: tag,
      level: level.index,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void d(String tag, String message) =>
      _log(message, tag: tag, level: LogLevel.debug);

  static void i(String tag, String message) =>
      _log(message, tag: tag, level: LogLevel.info);


  static void w(String tag, String message) =>
      _log(message, tag: tag, level: LogLevel.warning);

  static void e(String tag, String message, [Object? error, StackTrace? stackTrace]) =>
      _log(message, tag: tag, level: LogLevel.error, error: error, stackTrace: stackTrace);
}