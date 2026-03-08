import 'dart:io';

import 'package:twodotnulllauncher/widgets/log.dart';

class UpdaterUpdateFinalizer {
  static String get _installRoot {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null || localAppData.isEmpty) {
      throw StateError('LOCALAPPDATA not set');
    }

    return '$localAppData\\PeddaLauncher';
  }

  static String get _updatesDir => '$_installRoot\\updates';

  static String get _versionFile => '$_updatesDir\\updater_version.txt';

  static String get _zipFile => '$_updatesDir\\updater_update.zip';

  static String get _updaterNewDir => '$_updatesDir\\updater_new';

  static Future<void> finalize({
    required String updaterVersion,
  }) async {
    await Log.i('Finalizing updater update to version $updaterVersion');

    await File(_versionFile).writeAsString(
      updaterVersion,
      flush: true,
    );

    await Log.i('Updater version file updated to $updaterVersion');

    final zipFile = File(_zipFile);
    if (await zipFile.exists()) {
      await zipFile.delete();
    }

    await Log.i('Updater update zip file deleted');

    final updaterNewDir = Directory(_updaterNewDir);
    if (await updaterNewDir.exists()) {
      await updaterNewDir.delete(recursive: true);
    }

    await Log.i('Updater new directory deleted');
  }
}
