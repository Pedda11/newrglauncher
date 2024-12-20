class Utils {
  static String buildNumber = '0.1.0';

  static String timeSpanToDateTime(int timeSpan) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeSpan * 1000);

    return '${date.day}.${date.month}.${date.year} - ${date.hour}:${date.minute} Uhr';
  }
}
