import 'dart:io';
import 'package:twodotnulllauncher/widgets/log.dart';
import 'package:path/path.dart' as p;

class UpdaterPromoter {
  static String get _installRoot {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null || localAppData.isEmpty) {
      throw StateError('LOCALAPPDATA not set');
    }

    return '$localAppData\\PeddaLauncher';
  }

  static String get _updatesDir => '$_installRoot\\updates';

  static String get _updaterNewDir => '$_updatesDir\\updater_new';

  static Future<void> promote() async {
    final updatesDir = Directory(_updatesDir);
    final updaterNewDir = Directory(_updaterNewDir);

    if (!await updaterNewDir.exists()) {
      await Log.i('updater_new directory not found, skipping promotion');
      throw StateError(
          'updater_new directory not found: ${updaterNewDir.path}');
    }

    await Log.i(
        'Promoting updater from ${updaterNewDir.path} to ${updatesDir.path}');

    /// Remove old updater runtime files from updates root,
    /// but keep log and downloaded zip for now.
    await for (final entity in updatesDir.list(recursive: false)) {
      final name = p.basename(entity.path);

      final shouldKeep = name == 'logs' ||
          name == 'updater_update.zip' ||
          name == 'updater_new' ||
          name == 'updater_version.txt';

      if (shouldKeep) {
        continue;
      }

      await entity.delete(recursive: true);
    }

    await Log.i(
        'Old updater files removed from updates directory and copy started');

    /// Copy fresh updater files from updater_new into updates root.
    await for (final entity in updaterNewDir.list(recursive: true)) {
      final relativePath = entity.path.substring(updaterNewDir.path.length + 1);
      final targetPath = '${updatesDir.path}\\$relativePath';

      if (entity is Directory) {
        await Directory(targetPath).create(recursive: true);
      } else if (entity is File) {
        final targetFile = File(targetPath);
        await targetFile.parent.create(recursive: true);
        await entity.copy(targetPath);
      }
    }

    await Log.i('Updater promotion completed successfully');
  }
}
