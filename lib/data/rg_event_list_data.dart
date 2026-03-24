import 'rg_event_data.dart';

class RgEventListData {
  final int categoryId;
  final List<RgEventData> events;
  bool isExpanded;

  RgEventListData({
    required this.categoryId,
    required this.events,
    this.isExpanded = true,
  });
}
