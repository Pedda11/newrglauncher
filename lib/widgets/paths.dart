import 'dart:io';

class Paths {
  static String installRoot() {
    /// Per-user install root (no admin required)
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null || localAppData.isEmpty) {
      throw StateError('LOCALAPPDATA not set');
    }
    return '$localAppData\\PeddaLauncher';
  }

  static String launcherDir() => '${installRoot()}\\launcher';

  static String updatesDir() => '${installRoot()}\\updates';
}
