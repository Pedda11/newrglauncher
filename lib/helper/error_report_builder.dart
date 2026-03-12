import 'package:package_info_plus/package_info_plus.dart';
import 'package:twodotnulllauncher/helper/report_sanitizer.dart';

class LauncherErrorReportBuilder {
  static Future<String> build({
    required String errorMessage,
    required String stackTrace,
    required List<String> logTail,
  }) async {
    final info = await PackageInfo.fromPlatform();

    final buffer = StringBuffer();

    buffer.writeln('App Type: launcher');
    buffer.writeln('App Version: ${info.version}');
    buffer.writeln('Timestamp: ${DateTime.now().toUtc().toIso8601String()}');
    buffer.writeln('');

    final sanitizedErrorMessage = ReportSanitizer.sanitize(errorMessage);
    final sanitizedStackTrace = ReportSanitizer.sanitize(stackTrace);
    final sanitizedLogTail = ReportSanitizer.sanitizeLines(logTail);

    buffer.writeln('Error Message:');
    buffer.writeln(sanitizedErrorMessage);
    buffer.writeln('');

    buffer.writeln('Stack Trace:');
    buffer.writeln(sanitizedStackTrace);
    buffer.writeln('');

    buffer.writeln('Last Log Lines:');
    for (final line in sanitizedLogTail) {
      buffer.writeln(line);
    }

    return buffer.toString();
  }
}
