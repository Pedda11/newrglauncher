part of 'event_screen_cubit.dart';

@freezed
class EventScreenState with _$EventScreenState {
  const factory EventScreenState.initial() = _initial;

  const factory EventScreenState.initialized(
      {required List<RgEventListData> events}) = _initialized;
}
