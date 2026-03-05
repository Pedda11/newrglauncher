import 'package:auto_updater/auto_updater.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/launcher_endpoints.dart';
import '../../../services/update/launcher_status_api.dart';
import '../../../data/launcher_status_data.dart';
import '../../../data/semver_data.dart';
import '../../../data/startup_decision.dart';
import '../../../enum/e_startup_decision_type.dart';
import '../../../repository/main_repository.dart';
import '../../../repository/preferences_repository.dart';
import '../../../repository/settings_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../services/update/launcher_updater_listener.dart';

part 'splash_screen_state.dart';

part 'splash_screen_cubit.freezed.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final MainRepository mainRepository;
  final SettingsRepository settingsRepository;
  final PreferencesRepository preferencesRepository;
  final LauncherStatusApi launcherStatusApi;

  SplashScreenCubit(
      {required this.mainRepository,
      required this.settingsRepository,
      required this.preferencesRepository,
      required this.launcherStatusApi})
      : super(const SplashScreenState.initial());

  void initialize() async {
    emit(const SplashScreenState.checkingForUpdates());

    await initUpdater(launcherUpdaterListener);

    final currentVersion = await getLauncherVersion();

    final status = await launcherStatusApi.fetchStatus();

    final decision = decideStartup(
      status: status,
      currentLauncherVersion: currentVersion,
    );

    switch (decision.type) {
      case EStartupDecisionType.maintenance:
        emit(SplashScreenState.maintenance(
          motd: status.motd,
          banner: status.banner,
          links: status.links,
        ));
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

        /// Defer updater start to avoid running inside initialization microtask chain.
        Future.microtask(() => _startForcedUpdate());
        return;

      case EStartupDecisionType.proceed:
      case EStartupDecisionType.nonBlockingError:

        /// nonBlockingError behandeln wir später hübsch (banner/toast)
        emit(const SplashScreenState.initialized());
        return;
    }
  }

  Future<String> getLauncherVersion() async {
    final info = await PackageInfo.fromPlatform();
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

    /// Blocking error (optional)
    final err = status.error;
    if (err != null && (err.blocking ?? false)) {
      return StartupDecision(
        type: EStartupDecisionType.blockingError,
        status: status,
        message: err.message ?? 'Unknown error',
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

    /// Non-blocking error can still be shown as a banner/toast
    if (err != null) {
      return StartupDecision(
        type: EStartupDecisionType.nonBlockingError,
        status: status,
        message: err.message,
      );
    }

    return StartupDecision(
      type: EStartupDecisionType.proceed,
      status: status,
    );
  }

  Future<void> _startForcedUpdate() async {
    /// Trigger update check/download using the appcast feed.
    await autoUpdater.checkForUpdates();
  }

  Future<void> initUpdater(UpdaterListener updaterListener) async {
    await autoUpdater.setFeedURL(LauncherEndpoints.appcastUrl);
    autoUpdater.addListener(updaterListener);
  }
}
