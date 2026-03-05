import 'dart:async';

import 'package:auto_updater/auto_updater.dart';

enum UpdaterPhase {
  idle,
  checking,
  updateAvailable,
  downloading,
  downloaded,
  installing,
  noUpdate,
  error,
}

class UpdaterEvent {
  final UpdaterPhase phase;
  final String? message;
  final double? progress; // 0.0 - 1.0

  UpdaterEvent(this.phase, {this.message, this.progress});
}

class LauncherUpdaterService {
  final StreamController<UpdaterEvent> _events =
      StreamController<UpdaterEvent>.broadcast();

  Stream<UpdaterEvent> get events => _events.stream;

  bool _initialized = false;

  Future<void> init({required String appcastUrl}) async {
    /// Initialize auto_updater once and attach listeners.
    if (_initialized) return;
    _initialized = true;

    await autoUpdater.setFeedURL(appcastUrl);

    /*/// Listen to updater events.
    autoUpdater.onUpdaterError = (error) {
      _events.add(UpdaterEvent(UpdaterPhase.error, message: error.toString()));
    };

    autoUpdater.onUpdateAvailable = (info) {
      _events.add(UpdaterEvent(
        UpdaterPhase.updateAvailable,
        message: 'Update available: ${info.version}',
      ));
    };

    autoUpdater.onUpdateNotAvailable = () {
      _events.add(UpdaterEvent(UpdaterPhase.noUpdate));
    };

    autoUpdater.onDownloadProgress = (progress) {
      /// progress is 0..1
      _events.add(UpdaterEvent(
        UpdaterPhase.downloading,
        progress: progress,
      ));
    };

    autoUpdater.onUpdateDownloaded = (info) {
      _events.add(UpdaterEvent(
        UpdaterPhase.downloaded,
        message: 'Update downloaded: ${info.version}',
      ));
    };*/
  }

  Future<void> checkAndUpdate({bool installIfAvailable = true}) async {
    _events.add(UpdaterEvent(UpdaterPhase.checking));

    /// Triggers update check; download/install flow is handled by the plugin.
    await autoUpdater.checkForUpdates();

    if (installIfAvailable) {
      /// Some setups require an explicit call to install.
      /// If your auto_updater version doesn't expose installUpdate, ignore this.
      try {
        _events.add(UpdaterEvent(UpdaterPhase.installing));
        //await autoUpdater.installUpdate();
      } catch (_) {
        /// Not all platforms/versions expose installUpdate. Downloaded event is enough then.
      }
    }
  }

  Future<void> dispose() async {
    await _events.close();
  }
}
