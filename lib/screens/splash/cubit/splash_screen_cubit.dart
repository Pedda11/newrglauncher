import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../data/launcher_endpoints.dart';
import '../../../helper/error_report_builder.dart';
import '../../../repository/error_report_repository.dart';
import '../../../repository/error_repository.dart';
import '../../../widgets/gold_fake_history_test.dart';
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

  Future<void> acceptEula() async {
    await preferencesRepository.setEula(true);
    settingsRepository.eulaAccepted = true;
    initialize();
  }

  Future<void> initialize() async {
    //generateFakeGoldHistory is only for testing purposes. This replaces the real gold history with fake data. Make sure u backup your data before running this.!!!
    //await generateFakeGoldHistory();

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
          await Log.i('Blocking error encountered: ${decision.message}');
          emit(SplashScreenState.blockingError(
            message: decision.message ?? 'Fehler',
          ));
          return;

        case EStartupDecisionType.forceUpdate:
          await Log.i('Force update required. Message: ${decision.message}');
          emit(SplashScreenState.updateRequired(
            message: decision.message,
            status: status,
          ));

          await _prepareUpdaterIfNeeded(status);

          if (status.update == null) {
            await Log.i(
                'Launcher update information is missing in the status response.');
            throw StateError(
              'Launcher update required, but status.update is missing.',
            );
          }

          await Log.i(
              'Starting launcher update from ${status.update!.url} with expected SHA256: ${status.update!.sha256}');

          await LauncherUpdaterService.startUpdate(
            url: status.update!.url,
            sha256: status.update!.sha256,
            launcherVersion: status.launcherVersion,
          );

          await Log.i(
              'Launcher update process initiated. Exiting launcher to allow updater to run.');

          exit(0);

        case EStartupDecisionType.proceed:
          settingsRepository.eulaAccepted =
              await preferencesRepository.getEula() ?? false;
          await Log.i('EULA accepted: ${settingsRepository.eulaAccepted}');
          if (!settingsRepository.eulaAccepted) {
            await Log.i(
                'EULA has not been accepted. Prompting user to accept EULA.');
            emit(const SplashScreenState.eulaNotAccepted());
            return;
          }

          await Log.i('EULA accepted. Proceeding with initialization.');

          final wowPath = await preferencesRepository.getWowPath();

          if (wowPath == null) {
            await Log.i(
                'WoW path is not set. Prompting user to complete setup.');
            emit(const SplashScreenState.initializedFirstStart());
            return;
          }

          await Log.i(
              'All required settings are present. Initialization complete.');

          settingsRepository.fillWithExecutablePath(wowPath);
          settingsRepository.wowDataDirectoryPath =
              await preferencesRepository.getDataDirectoryPath();
          settingsRepository.secondsToWaitForGameToStart =
              await preferencesRepository.getWaitTillGameStarts();

          emit(const SplashScreenState.initialized());
          return;

        case EStartupDecisionType.nonBlockingError:
          await Log.i(
              'Non-blocking error encountered: ${decision.message}. Proceeding with initialization.');
          emit(const SplashScreenState.initialized());
          return;
      }
    } catch (e, st) {
      await Log.i('Error during initialization: $e');

      final logTail = await LogReader.readLastLines(10);

      final report = await LauncherErrorReportBuilder.build(
        errorMessage: e.toString(),
        stackTrace: st.toString(),
        logTail: logTail,
      );

      await ErrorReportRepository().uploadErrorReport(
        app: 'launcher',
        report: report,
      );

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
