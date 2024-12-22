import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../repository/preferences_repository.dart';
import '../../../repository/settings_repository.dart';

part 'settings_screen_state.dart';

part 'settings_screen_cubit.freezed.dart';

class SettingsScreenCubit extends Cubit<SettingsScreenState> {
  final SettingsRepository settingsRepository;
  final PreferencesRepository preferencesRepository;

  SettingsScreenCubit({
    required this.settingsRepository,
    required this.preferencesRepository,
  }) : super(const SettingsScreenState.initial());

  void initialize() async {
    final wowPath = await preferencesRepository.getWowPath();
    final dataPath = await preferencesRepository.getDataDirectoryPath();
    settingsRepository.secondsToWaitForGameToStart =
        await preferencesRepository.getWaitTillGameStarts() ?? 3;
    if (wowPath != null) {
      settingsRepository.fillWithExecutablePath(wowPath);

      settingsRepository.wowDataDirectory = dataPath;
      settingsRepository.wowRealmFilePath = '$dataPath/realmlist.wtf';
    }
    emit(SettingsScreenState.initialized());
  }

  void changeWowFilePath(String? path) async {
    if (path != null) {
      settingsRepository.fillWithExecutablePath(path);
      await preferencesRepository.setWowPath(path);

      List<String> dataFolder = [];

      final dataDirectory =
          Directory('${settingsRepository.wowRootFolderPath}Data');
      if (await dataDirectory.exists()) {
        dataFolder = dataDirectory
            .listSync()
            .whereType<Directory>()
            .map((entity) => entity.path)
            .toList();
      }
      emit(SettingsScreenState.chooseDataFolder(dataFolder: dataFolder));
    }
  }

  void changeDataDirectory(String? directoryName) async {
    if (directoryName != null) {
      settingsRepository.wowDataDirectory = directoryName;
      settingsRepository.wowRealmFilePath = '$directoryName/realmlist.wtf';
      await preferencesRepository.setDataDirectory(directoryName);
      emit(SettingsScreenState.settingsChanged());
      initialize();
    }
  }

  void deleteDataDirectory() async {
    settingsRepository.wowDataDirectory = null;
    settingsRepository.wowRealmFilePath = null;
    settingsRepository.wowDataDirectory = null;
    settingsRepository.wowRealmFilePath = null;
    settingsRepository.wowBackupDirectoryPath = null;
    settingsRepository.wowAddonsDirectoryPath = null;
    settingsRepository.wowAccountsDirectoryPath = null;

    await preferencesRepository.deleteSettings();
    await preferencesRepository.delDataDirectoryPath();
    emit(SettingsScreenState.settingsChanged());
    initialize();
  }

  void changeSecondsToWaitForGameToStart(int int) async {
    settingsRepository.secondsToWaitForGameToStart = int;
    await preferencesRepository.setWaitTillGameStarts(int);
    emit(SettingsScreenState.settingsChanged());
    initialize();
  }
}
