import '../../../data/launcher_status_data.dart';

class UpdaterUpdateValidator {
  static UpdateData requireUpdaterUpdate(LauncherStatusData status) {
    final updaterUpdate = status.updaterUpdate;

    if (updaterUpdate == null) {
      throw StateError(
        'Updater update is required, but status.updaterUpdate is missing.',
      );
    }

    if (updaterUpdate.url.isEmpty) {
      throw StateError(
        'Updater update is required, but updaterUpdate.url is empty.',
      );
    }

    if (updaterUpdate.sha256.isEmpty) {
      throw StateError(
        'Updater update is required, but updaterUpdate.sha256 is empty.',
      );
    }

    return updaterUpdate;
  }
}
