import 'dart:io';
import 'package:path/path.dart' as p;

import '../../../repository/settings_repository.dart';

class WowScanProgressData {
  final String currentDrive;
  final int scannedDirectories;
  final int scannedFiles;
  final int foundExecutables;

  const WowScanProgressData({
    required this.currentDrive,
    required this.scannedDirectories,
    required this.scannedFiles,
    required this.foundExecutables,
  });
}

Future<List<File>> findWowExe({
  required SettingsRepository settingsRepository,
  void Function(WowScanProgressData progress)? onProgress,
}) async {
  final List<File> foundExecutables = [];
  const wantedNames = {'Wow.exe', 'Wow_Original.exe'};

  int scannedDirectories = 0;
  int scannedFiles = 0;
  int progressTick = 0;

  for (final drive in settingsRepository.drives) {
    final root = Directory(drive);

    try {
      /// Schon hier kann "device not ready" fliegen.
      final exists = await root.exists();
      if (!exists) {
        continue;
      }
    } catch (e) {
      print('Skipping drive $drive: $e');
      continue;
    }

    onProgress?.call(
      WowScanProgressData(
        currentDrive: drive,
        scannedDirectories: scannedDirectories,
        scannedFiles: scannedFiles,
        foundExecutables: foundExecutables.length,
      ),
    );

    await _scanDirectoryForWowExe(
      directory: root,
      currentDrive: drive,
      foundExecutables: foundExecutables,
      wantedNames: wantedNames,
      onDirectoryScanned: () {
        scannedDirectories++;
        progressTick++;

        /// Nur gelegentlich Fortschritt senden
        if (progressTick % 200 == 0) {
          onProgress?.call(
            WowScanProgressData(
              currentDrive: drive,
              scannedDirectories: scannedDirectories,
              scannedFiles: scannedFiles,
              foundExecutables: foundExecutables.length,
            ),
          );
        }
      },
      onFileScanned: () {
        scannedFiles++;
        progressTick++;

        /// Nur gelegentlich Fortschritt senden
        if (progressTick % 200 == 0) {
          onProgress?.call(
            WowScanProgressData(
              currentDrive: drive,
              scannedDirectories: scannedDirectories,
              scannedFiles: scannedFiles,
              foundExecutables: foundExecutables.length,
            ),
          );
        }
      },
    );
  }

  /// Finaler Stand
  onProgress?.call(
    WowScanProgressData(
      currentDrive: '',
      scannedDirectories: scannedDirectories,
      scannedFiles: scannedFiles,
      foundExecutables: foundExecutables.length,
    ),
  );

  return foundExecutables;
}

Future<void> _scanDirectoryForWowExe({
  required Directory directory,
  required String currentDrive,
  required List<File> foundExecutables,
  required Set<String> wantedNames,
  required void Function() onDirectoryScanned,
  required void Function() onFileScanned,
}) async {
  final directoryName = p.basename(directory.path);

  /// Ordner ausschließen
  if (_shouldSkipDirectory(directory.path, directoryName, currentDrive)) {
    return;
  }

  onDirectoryScanned();

  try {
    await for (final entity in directory.list(
      recursive: false,
      followLinks: false,
    )) {
      if (entity is File) {
        onFileScanned();

        final fileName = p.basename(entity.path);

        if (wantedNames.contains(fileName)) {
          foundExecutables.add(entity);
        }
      } else if (entity is Directory) {
        await _scanDirectoryForWowExe(
          directory: entity,
          currentDrive: currentDrive,
          foundExecutables: foundExecutables,
          wantedNames: wantedNames,
          onDirectoryScanned: onDirectoryScanned,
          onFileScanned: onFileScanned,
        );
      }
    }
  } catch (e) {
    /// Nur diesen Ordner überspringen, nicht die ganze Drive killen
    print('Skipping ${directory.path}: $e');
  }
}

bool _shouldSkipDirectory(
  String fullPath,
  String directoryName,
  String currentDrive,
) {
  final normalizedPath = fullPath.toLowerCase().replaceAll('/', '\\');
  final normalizedDrive = currentDrive.toLowerCase().replaceAll('/', '\\');

  /// Alle Ordner mit Punkt am Anfang skippen
  if (directoryName.startsWith('.')) {
    return true;
  }

  /// Typische Problem-/unnötige Ordner skippen
  const blockedNames = {
    r'$recycle.bin',
    'system volume information',
  };

  if (blockedNames.contains(directoryName.toLowerCase())) {
    return true;
  }

  /// Nur für C: ein paar unnötige Monster skippen
  if (normalizedDrive.startsWith('c:')) {
    if (normalizedPath == r'c:\windows' ||
        normalizedPath.startsWith(r'c:\windows\\')) {
      return true;
    }

    if (normalizedPath == r'c:\program files' ||
        normalizedPath.startsWith(r'c:\program files\\')) {
      return true;
    }

    if (normalizedPath == r'c:\program files (x86)' ||
        normalizedPath.startsWith(r'c:\program files (x86)\\')) {
      return true;
    }
  }

  return false;
}
