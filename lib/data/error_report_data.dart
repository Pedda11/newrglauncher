class ErrorReportData {
  final String appType;
  final String appVersion;
  final String errorMessage;
  final String stackTrace;
  final List<String> logTail;
  final DateTime timestamp;

  ErrorReportData({
    required this.appType,
    required this.appVersion,
    required this.errorMessage,
    required this.stackTrace,
    required this.logTail,
    required this.timestamp,
  });
}
