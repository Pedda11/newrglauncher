import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/rg_event_data.dart';

class RgEventParser {
  static const _baseUrl = 'https://db.rising-gods.de';
  static const _iconBaseUrl = '$_baseUrl/static/images/wow/icons/small';

  Future<List<RgEventData>> fetchEvents() async {
    final res = await http.get(
      Uri.parse('$_baseUrl/?events'),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load event page');
    }

    final body = res.body;

    final iconMap = _extractIconMap(body);
    final eventData = _extractHolidayListJson(body);

    final events = <RgEventData>[];

    for (final item in eventData) {
      final id = item['id'];
      final name = item['name'];
      final startDate = item['startDate'];
      final endDate = item['endDate'];
      final categoryId = item['category'];

      if (id is! int ||
          name is! String ||
          startDate is! String ||
          endDate is! String ||
          categoryId is! int) {
        continue;
      }

      final start = _parseRgDateTime(startDate);
      final end = _parseRgDateTime(endDate);

      if (start == null || end == null) {
        continue;
      }

      final iconName = iconMap[id];
      final iconUrl = iconName == null ? '' : '$_iconBaseUrl/$iconName.jpg';

      events.add(
        RgEventData(
          id: id,
          name: name,
          start: start,
          end: end,
          iconUrl: iconUrl,
          detailsUrl: '$_baseUrl/?event=$id',
          categoryId: categoryId,
        ),
      );
    }

    events.sort((a, b) {
      final catCompare = a.categoryName.compareTo(b.categoryName);
      if (catCompare != 0) {
        return catCompare;
      }
      return a.start.compareTo(b.start);
    });

    return events.where((e) => e.isTodayOrFuture).toList();
  }

  Map<int, String> _extractIconMap(String body) {
    final result = <int, String>{};

    final regex = RegExp(
      r'_\[(\d+)\]=\{"icon":"([^"]+)"',
    );

    for (final match in regex.allMatches(body)) {
      final id = int.tryParse(match.group(1) ?? '');
      final icon = match.group(2);

      if (id != null && icon != null && icon.isNotEmpty) {
        result[id] = icon;
      }
    }

    return result;
  }

  List<Map<String, dynamic>> _extractHolidayListJson(String body) {
    final match = RegExp(
      r'new Listview\(\{"id":"holidays".*?"data":(\[.*?\]),"tabs":myTabs',
      dotAll: true,
    ).firstMatch(body);

    if (match == null) {
      throw Exception('Could not find holidays list data');
    }

    final jsonArray = match.group(1);
    if (jsonArray == null || jsonArray.isEmpty) {
      throw Exception('Holiday data array is empty');
    }

    final decoded = jsonDecode(jsonArray);

    if (decoded is! List) {
      throw Exception('Holiday data is not a list');
    }

    return decoded.whereType<Map>().map((e) {
      return e.map((key, value) => MapEntry(key.toString(), value));
    }).toList();
  }

  DateTime? _parseRgDateTime(String input) {
    final match = RegExp(
      r'^(\d{4})\/(\d{2})\/(\d{2}) (\d{2}):(\d{2}):(\d{2})$',
    ).firstMatch(input);

    if (match == null) {
      return null;
    }

    return DateTime(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.parse(match.group(6)!),
    );
  }
}
