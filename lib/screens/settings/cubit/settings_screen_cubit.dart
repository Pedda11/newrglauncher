import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twodotnulllauncher/utils/launcher_pin_utils.dart';
import '../../../data/launcher_pin_data.dart';
import '../../../repository/credential_repository.dart';
import '../../../repository/preferences_repository.dart';
import '../../../repository/settings_repository.dart';
import '../../../widgets/log.dart';
import '../functions/WowScanProgressData.dart';

part 'settings_screen_state.dart';

part 'settings_screen_cubit.freezed.dart';

class SettingsScreenCubit extends Cubit<SettingsScreenState> {
  final SettingsRepository settingsRepository;
  final PreferencesRepository preferencesRepository;
  final CredentialRepository credentialRepository;

  SettingsScreenCubit({
    required this.settingsRepository,
    required this.preferencesRepository,
    required this.credentialRepository,
  }) : super(const SettingsScreenState.initial());

  LauncherPinUtils? _launcherPinUtils;

  Future<List<String>> getAvailableDrives() async {
    await Log.info('Getting available drives without wmic');

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
        await Log.info('Drive is accessible: $drivePath');
      } catch (e) {
        await Log.info('Skipping drive $drivePath: $e');
      }
    }

    await Log.info('Drive scan complete: $drives');
    return drives;
  }

  Future<void> initialize() async {
    _launcherPinUtils =
        LauncherPinUtils(credentialRepository: credentialRepository);

    emit(const SettingsScreenState.scanningForDrives());
    await Log.info('Initializing SettingsScreenCubit');

    final drives = await getAvailableDrives();
    final drivesWithSlash = <String>[];

    for (final drive in drives) {
      await Log.info('Found drive: $drive');
      drivesWithSlash.add('$drive\\');
    }

    settingsRepository.drives = drivesWithSlash;

    await Log.info('Available drives: ${settingsRepository.drives}');
    await Log.info('Settings initialization complete');

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

  Future<void> saveLauncherPin(String pinString) async {
    final normalizedPin = pinString.trim();

    if (!RegExp(r'^\d{4}$').hasMatch(normalizedPin)) {
      throw ArgumentError('PIN must be exactly 4 digits.');
    }

    final random = Random.secure();
    final saltBytes = Uint8List.fromList(
      List<int>.generate(16, (_) => random.nextInt(256)),
    );
    final saltBase64 = base64Encode(saltBytes);

    final hashInput = utf8.encode('$normalizedPin:$saltBase64');
    final hashBytes = sha256.convert(hashInput).bytes;
    final hashBase64 = base64Encode(hashBytes);

    final pinData = LauncherPinData(
      salt: saltBase64,
      hash: hashBase64,
    );

    await credentialRepository.saveLauncherPin(pinData.toRawJson());
  }

  Future<bool> hasLauncherPin() async {
    return _launcherPinUtils!.hasLauncherPin();
  }

  Future<bool> verifyLauncherPin(String pinString) async {
    return _launcherPinUtils!.verifyLauncherPin(pinString);
  }

  Future<void> deleteLauncherPin() async {
    final hasPin = await _launcherPinUtils!.hasLauncherPin();

    if (!hasPin) {
      return;
    }

    await credentialRepository.deleteLauncherPin();
  }
}
