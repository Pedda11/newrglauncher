import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twodotnulllauncher/enum/e_event_ui_status.dart';
import '../../../data/rg_event_data.dart';
import '../../../data/rg_event_list_data.dart';
import '../../../helper/rg_event_parser.dart';

part 'event_screen_state.dart';

part 'event_screen_cubit.freezed.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  EventScreenCubit() : super(const EventScreenState.initial());

  final RgEventParser _rgEventParser = RgEventParser();

  List<RgEventListData> _groupedEventList = [];

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

    _groupedEventList =
        await Future.wait(_groupedEventList.map((e) => setEventStatuses(e)));

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

  Future<RgEventListData> setEventStatuses(RgEventListData events) async {
    final now = DateTime.now();
    RgEventData? nextUpcomingEvent;

    // Find the next upcoming event (earliest start time after now)
    for (final event in events.events) {
      if (event.start.isAfter(now)) {
        if (nextUpcomingEvent == null ||
            event.start.isBefore(nextUpcomingEvent.start)) {
          nextUpcomingEvent = event;
        }
      }
    }

    // Update colors for all events
    final updatedEvents = events.events.map((event) {
      // Check if event is currently active (between start and end)
      final isActive = !event.start.isAfter(now) && event.end.isAfter(now);

      if (isActive) {
        // Active events get green color
        return RgEventData(
          id: event.id,
          name: event.name,
          start: event.start,
          end: event.end,
          iconUrl: event.iconUrl,
          detailsUrl: event.detailsUrl,
          categoryId: event.categoryId,
          uiStatus: EEventUiStatus.active,
        );
      } else if (nextUpcomingEvent != null &&
          event.id == nextUpcomingEvent.id) {
        // Next upcoming event gets yellow color
        return RgEventData(
          id: event.id,
          name: event.name,
          start: event.start,
          end: event.end,
          iconUrl: event.iconUrl,
          detailsUrl: event.detailsUrl,
          categoryId: event.categoryId,
          uiStatus: EEventUiStatus.upcoming,
        );
      } else {
        // All other events get white color
        return RgEventData(
          id: event.id,
          name: event.name,
          start: event.start,
          end: event.end,
          iconUrl: event.iconUrl,
          detailsUrl: event.detailsUrl,
          categoryId: event.categoryId,
          uiStatus: EEventUiStatus.none,
        );
      }
    }).toList();

    return RgEventListData(
      categoryId: events.categoryId,
      events: updatedEvents,
      isExpanded: events.isExpanded,
    );
  }
}
