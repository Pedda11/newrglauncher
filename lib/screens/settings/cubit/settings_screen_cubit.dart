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

  Future<List<String>> getAvailableDrives() async {
    List<String> drives = [];
    ProcessResult result =
        await Process.run('wmic', ['logicaldisk', 'get', 'name']);
    if (result.exitCode == 0) {
      drives = result.stdout
          .toString()
          .split('\n')
          .where((line) => line.trim().isNotEmpty && line.contains(':'))
          .map((line) => line.trim())
          .toList();
    }
    return drives;
  }

  void initialize() async {
    List<String> drives = await getAvailableDrives();
    List<String> drivesWithSlash = [];
    for (String s in drives) {
      drivesWithSlash.add('$s//');
    }
    settingsRepository.drives = drivesWithSlash;

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
    emit(SettingsScreenState.changingSettings());
    if (directoryName != null) {
      settingsRepository.wowDataDirectory = directoryName;
      settingsRepository.wowRealmFilePath = '$directoryName/realmlist.wtf';
      await preferencesRepository.setDataDirectory(directoryName);
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
    emit(const SettingsScreenState.changingSettings());
    initialize();
  }

  void changeSecondsToWaitForGameToStart(int value) async {
    emit(const SettingsScreenState.changingSettings());
    settingsRepository.secondsToWaitForGameToStart = value;
    await preferencesRepository.setWaitTillGameStarts(value);
    emit(const SettingsScreenState.initialized());
  }
}
