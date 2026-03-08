import 'dart:io';

class UpdaterVersionReader {
  static String get _installRoot {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null || localAppData.isEmpty) {
      throw StateError('LOCALAPPDATA not set');
    }

    return '$localAppData\\PeddaLauncher';
  }

  static String get _versionFilePath =>
      '$_installRoot\\updates\\updater_version.txt';

  static Future<String?> readInstalledUpdaterVersion() async {
    final file = File(_versionFilePath);

    if (!await file.exists()) {
      return null;
    }

    final version = (await file.readAsString()).trim();

    if (version.isEmpty) {
      return null;
    }

    return version;
  }
}
