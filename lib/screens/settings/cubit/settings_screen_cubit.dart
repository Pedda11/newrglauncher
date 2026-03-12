import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../repository/preferences_repository.dart';
import '../../../repository/settings_repository.dart';
import '../../../widgets/log.dart';
import '../functions/WowScanProgressData.dart';

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
    await Log.i('Getting available drives without wmic');

    final drives = <String>[];

    for (var code = 65; code <= 90; code++) {
      final letter = String.fromCharCode(code);
      final drivePath = '$letter:';
      final dir = Directory('$drivePath\\');

      try {
        final exists = await dir.exists();

        if (!exists) {
          continue;
        }

        /// Force a real access check so empty card readers / broken drives do not slip through.
        await dir.list(recursive: false, followLinks: false).firstWhere(
              (_) => true,
              orElse: () => File(''),
            );

        drives.add(drivePath);
        await Log.i('Drive is accessible: $drivePath');
      } catch (e) {
        await Log.i('Skipping drive $drivePath: $e');
      }
    }

    await Log.i('Drive scan complete: $drives');
    return drives;
  }

  Future<void> initialize() async {
    emit(const SettingsScreenState.scanningForDrives());
    await Log.i('Initializing SettingsScreenCubit');

    final drives = await getAvailableDrives();
    final drivesWithSlash = <String>[];

    for (final drive in drives) {
      await Log.i('Found drive: $drive');
      drivesWithSlash.add('$drive\\');
    }

    settingsRepository.drives = drivesWithSlash;

    await Log.i('Available drives: ${settingsRepository.drives}');
    await Log.i('Settings initialization complete');

    emit(const SettingsScreenState.initialized());
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
    emit(const SettingsScreenState.changingSettings());
    if (directoryName != null) {
      settingsRepository.wowRealmListFilePath = '$directoryName/realmlist.wtf';
      await preferencesRepository.setDataDirectory(directoryName);
      initialize();
    }
  }

  void deleteDataDirectory() async {
    settingsRepository.wowRealmListFilePath = null;
    settingsRepository.wowRealmListFilePath = null;
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

  Future<void> cancelWowExeSearch() async {
    settingsRepository.scanIsCancelled = true;
  }

  Future<void> findWowExeAndEmitProgress() async {
    settingsRepository.scanIsCancelled = false;
    final files = await findWowExe(
      onProgress: (progress) {
        if (isClosed) return;

        settingsRepository.foundWowExecutables = progress.foundExecutables;

        emit(SettingsScreenState.searchProgress(
          searchedFolders: progress.scannedDirectories,
          searchedFiles: progress.scannedFiles,
          foundExecutables: progress.foundExecutables,
        ));
      },
      settingsRepository: settingsRepository,
    );

    if (files.isEmpty) {
      emit(const SettingsScreenState.initialized());
      return;
    }

    emit(SettingsScreenState.foundWowExe(wowFiles: files));
  }
}
