import 'dart:io';

class UpdaterZipDownloader {
  static String get _installRoot {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null || localAppData.isEmpty) {
      throw StateError('LOCALAPPDATA not set');
    }

    return '$localAppData\\PeddaLauncher';
  }

  static String get _updatesDir => '$_installRoot\\updates';

  static String get targetZipPath => '$_updatesDir\\updater_update.zip';

  static Future<File> downloadUpdaterZip({
    required String url,
  }) async {
    final updatesDir = Directory(_updatesDir);
    await updatesDir.create(recursive: true);

    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode != 200) {
      throw StateError(
        'Updater zip download failed: ${response.statusCode}',
      );
    }

    final file = File(targetZipPath);
    final sink = file.openWrite();

    await response.pipe(sink);

    await sink.flush();
    await sink.close();

    return file;
  }
}
