class RgEventData {
  final int id;
  final String name;
  final DateTime start;
  final DateTime end;
  final String iconUrl;
  final String detailsUrl;
  final int categoryId;

  const RgEventData({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    required this.iconUrl,
    required this.detailsUrl,
    required this.categoryId,
  });

  bool get isTodayOrFuture {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !end.isBefore(today);
  }

  String get categoryName {
    switch (categoryId) {
      case 101:
        return 'Arenasaison';
      case 3:
        return 'Spieler vs. Spieler';
      case 2:
        return 'Wiederkehrend';
      case 1:
        return 'Feiertage';
      case 100:
        return 'Boost Events';
      default:
        return 'Unbekannt';
    }
  }

  String get formattedDateRange {
    return '${_formatDate(start)} - ${_formatDate(end)}';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = (date.year % 100).toString().padLeft(2, '0');

    return '$day.$month.$year';
  }
}
