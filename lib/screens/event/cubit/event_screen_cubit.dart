import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/rg_event_data.dart';
import '../../../data/rg_event_list_data.dart';
import '../../../helper/rg_event_parser.dart';

part 'event_screen_state.dart';

part 'event_screen_cubit.freezed.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  EventScreenCubit() : super(const EventScreenState.initial());

  final RgEventParser _rgEventParser = RgEventParser();

  final List<RgEventListData> _groupedEventList = [];

  Future<void> initialize() async {
    List<RgEventData> events = await _rgEventParser.fetchEvents();

    // Group events by category
    List<List<RgEventData>> groupedEvents = [];

    for (final event in events) {
      final category = event.categoryId;
      final categoryIndex = groupedEvents
          .indexWhere((group) => group.first.categoryId == category);
      if (categoryIndex == -1) {
        groupedEvents.add([event]);
      } else {
        groupedEvents[categoryIndex].add(event);
      }
    }

    for (final group in groupedEvents) {
      final category = group.first.categoryId;
      const isExpanded = true;
      _groupedEventList.add(RgEventListData(
          categoryId: category, events: group, isExpanded: isExpanded));
    }

    emit(EventScreenState.initialized(events: _groupedEventList));
  }

  Future<void> toggleExpansion(int categoryId) async {
    emit(const EventScreenState.initial());
    _groupedEventList
            .where((element) => element.categoryId == categoryId)
            .first
            .isExpanded =
        !_groupedEventList
            .where((element) => element.categoryId == categoryId)
            .first
            .isExpanded;

    emit(EventScreenState.initialized(events: _groupedEventList));
  }
}
