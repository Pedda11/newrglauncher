import 'dart:io';

class UpdaterDownloader {
  static String get _installRoot {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null || localAppData.isEmpty) {
      throw StateError('LOCALAPPDATA not set');
    }

    return '$localAppData\\PeddaLauncher';
  }

  static String get _updatesDir => '$_installRoot\\updates';

  static String get targetPath => '$_updatesDir\\setup_rg_launcher_new.exe';

  static Future<File> downloadUpdater({
    required String url,
  }) async {
    final updatesDir = Directory(_updatesDir);
    await updatesDir.create(recursive: true);

    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode != 200) {
      throw StateError('Updater download failed: ${response.statusCode}');
    }

    final file = File(targetPath);
    final sink = file.openWrite();

    await response.pipe(sink);

    await sink.flush();
    await sink.close();

    return file;
  }
}
