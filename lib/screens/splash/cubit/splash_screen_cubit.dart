import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../data/launcher_endpoints.dart';
import '../../../widgets/log.dart';
import '../core_functions/updater_promoter.dart';
import '../core_functions/updater_update_finalizer.dart';
import '../core_functions/updater_version_checker.dart';
import '../core_functions/updater_update_validator.dart';
import '../core_functions/updater_zip_downloader.dart';
import '../core_functions/updater_zip_extractor.dart';
import '../core_functions/updater_zip_hash_verifier.dart';
import '../../../services/update/launcher_status_api.dart';
import '../../../data/launcher_status_data.dart';
import '../../../data/semver_data.dart';
import '../../../data/startup_decision.dart';
import '../../../enum/e_startup_decision_type.dart';
import '../../../repository/main_repository.dart';
import '../../../repository/preferences_repository.dart';
import '../../../repository/settings_repository.dart';
import '../../../services/update/launcher_updater_service.dart';

part 'splash_screen_state.dart';

part 'splash_screen_cubit.freezed.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final SettingsRepository settingsRepository;
  final PreferencesRepository preferencesRepository;

  SplashScreenCubit(
      {required this.settingsRepository, required this.preferencesRepository})
      : super(const SplashScreenState.initial());

  Future<void> initialize() async {
    await Log.i('Update check started.');
    try {
      emit(const SplashScreenState.checkingForUpdates());

      final currentVersion = await getLauncherVersion();
      final status =
          await LauncherStatusApi(LauncherEndpoints.statusUri).fetchStatus();

      final decision = decideStartup(
        status: status,
        currentLauncherVersion: currentVersion,
      );

      await Log.i('Startup decision: ${decision.type}');

      switch (decision.type) {
        case EStartupDecisionType.maintenance:
          emit(const SplashScreenState.maintenance());
          return;

        case EStartupDecisionType.blockingError:
          emit(SplashScreenState.blockingError(
            message: decision.message ?? 'Fehler',
          ));
          return;

        case EStartupDecisionType.forceUpdate:
          emit(SplashScreenState.updateRequired(
            message: decision.message,
            status: status,
          ));

          await _prepareUpdaterIfNeeded(status);

          if (status.update == null) {
            throw StateError(
              'Launcher update required, but status.update is missing.',
            );
          }

          await LauncherUpdaterService.startUpdate(
            url: status.update!.url,
            sha256: status.update!.sha256,
            launcherVersion: status.launcherVersion,
          );

          exit(0);

        case EStartupDecisionType.proceed:
          settingsRepository
              .fillWithExecutablePath(await preferencesRepository.getWowPath());
          settingsRepository.wowDataDirectoryPath =
              await preferencesRepository.getDataDirectoryPath();
          settingsRepository.secondsToWaitForGameToStart =
              await preferencesRepository.getWaitTillGameStarts();
          emit(const SplashScreenState.initialized());
          return;

        case EStartupDecisionType.nonBlockingError:
          emit(const SplashScreenState.initialized());
          return;
      }
    } catch (e, st) {
      debugPrint('Splash initialize error: $e');
      debugPrintStack(stackTrace: st);

      emit(SplashScreenState.failed(errorMsg: e.toString()));
    }
  }

  Future<String> getLauncherVersion() async {
    final info = await PackageInfo.fromPlatform();
    await Log.i('Current launcher version: ${info.version}');
    return info.version;
  }

  StartupDecision decideStartup({
    required LauncherStatusData status,
    required String currentLauncherVersion,
  }) {
    /// Maintenance has absolute priority.
    if (status.maintenance) {
      return StartupDecision(
        type: EStartupDecisionType.maintenance,
        status: status,
        message: status.motd,
      );
    }

    final current = SemverData.parse(currentLauncherVersion);
    final latest = SemverData.parse(status.launcherVersion);

    /// Force update if a newer launcher version exists
    if (current.compareTo(latest) < 0) {
      return StartupDecision(
        type: EStartupDecisionType.forceUpdate,
        status: status,
        message: 'Neue Launcher-Version verfügbar (${status.launcherVersion}).',
      );
    }

    return StartupDecision(
      type: EStartupDecisionType.proceed,
      status: status,
    );
  }

  Future<void> _prepareUpdaterIfNeeded(LauncherStatusData status) async {
    final needsUpdaterUpdate =
        await UpdaterVersionChecker.needsUpdaterUpdate(status: status);

    await Log.i('Updater update needed: $needsUpdaterUpdate');

    if (!needsUpdaterUpdate) {
      return;
    }

    final updaterUpdate = UpdaterUpdateValidator.requireUpdaterUpdate(status);

    await Log.i(
        'Starting download of updater version ${status.updaterVersion} from ${updaterUpdate.url}');

    final zipFile = await UpdaterZipDownloader.downloadUpdaterZip(
      url: updaterUpdate.url,
    );

    await Log.i('Download completed. Verifying hash...');

    await UpdaterZipHashVerifier.verify(
      filePath: zipFile.path,
      expectedHex: updaterUpdate.sha256,
    );

    await Log.i('Hash verification passed. Extracting zip...');

    await UpdaterZipExtractor.extractZip(
      zipPath: zipFile.path,
    );

    await Log.i('Extraction completed. Promoting updater...');

    await UpdaterPromoter.promote();

    await Log.i('Updater promotion completed. Finalizing update...');

    await UpdaterUpdateFinalizer.finalize(
      updaterVersion: status.updaterVersion,
    );
  }
}
