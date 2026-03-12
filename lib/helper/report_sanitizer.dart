class ReportSanitizer {
  static String sanitize(String input) {
    final regex = RegExp(r'Users\\([^\\]+)', caseSensitive: false);

    return input.replaceAllMapped(regex, (_) => r'Users\####');
  }

  static List<String> sanitizeLines(List<String> lines) {
    return lines.map(sanitize).toList();
  }
}
