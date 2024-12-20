part of 'settings_screen_cubit.dart';

@freezed
class SettingsScreenState with _$SettingsScreenState {
  const factory SettingsScreenState.initial() = _initial;
  const factory SettingsScreenState.initialized() = _initialized;
  const factory SettingsScreenState.settingsChanged() = _settingsChanged;
  const factory SettingsScreenState.fileOrDirectoryNotFound() =
      _fileOrDirectoryNotFound;
}
