import 'dart:async';
import 'dart:io';

import 'package:auto_updater/auto_updater.dart';

final LauncherUpdaterListener launcherUpdaterListener =
    LauncherUpdaterListener();

class LauncherUpdaterListener with UpdaterListener {
  bool _exitScheduled = false;

  @override
  void onUpdaterUpdateDownloaded(AppcastItem? item) {
    print('/// updater: downloaded -> closing launcher');

    /// Avoid double-exit if callback fires more than once.
    if (_exitScheduled) return;
    _exitScheduled = true;

    /// Give WinSparkle a moment to start the installer.
    Timer(const Duration(milliseconds: 500), () {
      exit(0);
    });
  }

  @override
  void onUpdaterError(UpdaterError? error) {
    print('/// updater: error: $error');
  }

  @override
  void onUpdaterBeforeQuitForUpdate(AppcastItem? appcastItem) {
    // TODO: implement onUpdaterBeforeQuitForUpdate
  }

  @override
  void onUpdaterCheckingForUpdate(Appcast? appcast) {
    // TODO: implement onUpdaterCheckingForUpdate
  }

  @override
  void onUpdaterUpdateAvailable(AppcastItem? appcastItem) {
    // TODO: implement onUpdaterUpdateAvailable
  }

  @override
  void onUpdaterUpdateNotAvailable(UpdaterError? error) {
    // TODO: implement onUpdaterUpdateNotAvailable
  }
}
