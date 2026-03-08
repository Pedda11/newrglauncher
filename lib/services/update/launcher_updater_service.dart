import 'dart:io';

import '../../helper/process_info.dart';
import '../../widgets/log.dart';

class LauncherUpdaterService {
  static String get _installRoot {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null || localAppData.isEmpty) {
      throw StateError('LOCALAPPDATA not set');
    }

    return '$localAppData\\PeddaLauncher';
  }

  static String get _setupExe =>
      '$_installRoot\\updates\\setup_rg_launcher.exe';

  static Future<void> startUpdate({
    required String url,
    required String sha256,
    required String launcherVersion,
  }) async {
    final setup = File(_setupExe);

    if (!await setup.exists()) {
      await Log.i('Updater setup executable not found at $_setupExe');
      throw StateError('Updater not found: $_setupExe');
    }

    final pid = ProcessInfoUtil.currentPid();

    await Log.i(
        'Starting updater with PID $pid, URL: $url, SHA256: $sha256, Launcher Version: $launcherVersion');

    await Process.start(
      setup.path,
      [
        '--update',
        '--pid',
        pid.toString(),
        '--url',
        url,
        '--sha256',
        sha256,
        '--launcherVersion',
        launcherVersion,
      ],
      mode: ProcessStartMode.detached,
      runInShell: false,
      workingDirectory: '$_installRoot\\updates',
    );
  }
}
