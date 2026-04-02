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

  /// New: Data directory
  static String dataDir() => '${installRoot()}\\data';

  /// New: Gold history file path
  static String goldHistoryFile() => '${dataDir()}\\gold_history.json';

  /// Optional helper: ensure directory exists
  static Future<void> ensureDataDirExists() async {
    final dir = Directory(dataDir());
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }
}
