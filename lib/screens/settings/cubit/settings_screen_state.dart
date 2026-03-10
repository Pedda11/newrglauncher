part of 'settings_screen_cubit.dart';

@Freezed(equal: false)
class SettingsScreenState with _$SettingsScreenState {
  const factory SettingsScreenState.initial() = _initial;

  const factory SettingsScreenState.initialized() = _initialized;

  const factory SettingsScreenState.searchingWowExe() = _searchingWowExe;

  const factory SettingsScreenState.searchProgress(
      {required int searchedFolders,
      required int searchedFiles,
      required List<File> foundExecutables}) = _searchProgress;

  const factory SettingsScreenState.foundWowExe(
      {required List<File> wowFiles}) = _foundWowExe;

  const factory SettingsScreenState.chooseDataFolder(
      {required List<String> dataFolder}) = _chooseDataFolder;

  const factory SettingsScreenState.changingSettings() = _changingSettings;

  const factory SettingsScreenState.fileOrDirectoryNotFound() =
      _fileOrDirectoryNotFound;
}
