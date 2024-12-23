import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../repository/main_repository.dart';
import '../../../repository/preferences_repository.dart';
import '../../../repository/settings_repository.dart';
import '../../../services/update_service.dart';

part 'splash_screen_state.dart';

part 'splash_screen_cubit.freezed.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final MainRepository mainRepository;
  final SettingsRepository settingsRepository;
  final PreferencesRepository preferencesRepository;

  SplashScreenCubit({
    required this.mainRepository,
    required this.settingsRepository,
    required this.preferencesRepository,
  }) : super(const SplashScreenState.initial());

  void initialize() async {
    emit(SplashScreenState.checkingForUpdates());
    try {
      if (!kDebugMode) {
        await UpdateService().deleteUpdateFiles();
        final updateNeeded = await UpdateService().checkForUpdate();
        if (updateNeeded) {
          emit(const SplashScreenState.updateAvailable());
          await Future.delayed(const Duration(seconds: 3));
          UpdateService().updateApp();
          return;
        }
      }

      final wowPath = await preferencesRepository.getWowPath();
      final dataPath = await preferencesRepository.getDataDirectoryPath();
      settingsRepository.secondsToWaitForGameToStart =
          await preferencesRepository.getWaitTillGameStarts() ?? 3;
      if (wowPath != null) {
        settingsRepository.fillWithExecutablePath(wowPath);

        settingsRepository.wowDataDirectory = dataPath;
        settingsRepository.wowRealmFilePath = '$dataPath/realmlist.wtf';
      }
      emit(const SplashScreenState.initialized());

      ;
    } catch (e) {
      emit(SplashScreenState.failed(errorMsg: e.toString()));
    }
  }
}
