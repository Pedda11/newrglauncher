import '../../../data/launcher_status_data.dart';
import '../../../data/semver_data.dart';
import 'updater_version_reader.dart';

class UpdaterVersionChecker {
  static Future<bool> needsUpdaterUpdate({
    required LauncherStatusData status,
  }) async {
    final installedVersion =
        await UpdaterVersionReader.readInstalledUpdaterVersion();

    /// If no updater version is installed yet, we treat it as needing an update.
    if (installedVersion == null) {
      return true;
    }

    final installed = SemverData.parse(installedVersion);
    final server = SemverData.parse(status.updaterVersion);

    return installed.compareTo(server) < 0;
  }
}
