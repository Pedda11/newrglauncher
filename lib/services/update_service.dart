import 'dart:io';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateService {
  Future<bool> checkForUpdate() async {
    // Get the current directory path
    final currentDir = Directory.current.path;

    // FTP server details
    const ftpAddress = '144.76.163.80';
    const ftpUser = 'wow_launcher';
    const ftpPass = 'wow_launcher_01';
    const versionFileName = 'version.txt';
    final localVersionFilePath = '$currentDir/$versionFileName';

    try {
      // Connect to FTP server and download the version file
      FTPConnect ftpConnect =
          FTPConnect(ftpAddress, user: ftpUser, pass: ftpPass);
      await ftpConnect.connect();
      bool versionFileDownloaded = await ftpConnect.downloadFileWithRetry(
          versionFileName, File(localVersionFilePath));
      await ftpConnect.disconnect();

      if (versionFileDownloaded) {
        // Read the version from the downloaded file
        String latestVersion = await File(localVersionFilePath).readAsString();

        // Get the current app version
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String currentVersion = packageInfo.version;

        // Compare versions
        return latestVersion.trim() != currentVersion.trim();
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateApp() async {
    // Get the current directory path
    final currentDir = Directory.current.path;

    // FTP server details
    const ftpAddress = '144.76.163.80';
    const ftpUser = 'wow_launcher';
    const ftpPass = 'wow_launcher_01';
    const updateFileName = 'launcher.zip';
    final localUpdateFilePath = '$currentDir/$updateFileName';

    try {
      // Connect to FTP server and download the update file
      FTPConnect ftpConnect =
          FTPConnect(ftpAddress, user: ftpUser, pass: ftpPass);
      await ftpConnect.connect();
      bool updateFileDownloaded = await ftpConnect.downloadFileWithRetry(
          updateFileName, File(localUpdateFilePath));
      await ftpConnect.disconnect();

      if (updateFileDownloaded) {
        // Path to the .bat file
        final batFilePath = '$currentDir/update.bat';

        // Content of the .bat file
        final batContent = '''
          @echo off
          taskkill /F /IM twodotnulllauncher.exe
          timeout /t 2 /nobreak
          del /F /Q "$currentDir\\twodotnulllauncher.exe"
          powershell -Command "Expand-Archive -Path '$currentDir\\$updateFileName' -DestinationPath '$currentDir\\' -Force"
          start "" "$currentDir\\twodotnulllauncher.exe"
          timeout /t 2 /nobreak
          exit
          ''';

        // Create the .bat file
        final batFile = File(batFilePath);
        await batFile.writeAsString(batContent);

        // Execute the .bat file
        await Process.start('cmd.exe', ['/c', batFilePath]);
      } else {
        print('Failed to download the update file from FTP server.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteUpdateFiles() async {
    // Get the current directory path
    final currentDir = Directory.current.path;

    // File paths
    const updateFileName = 'launcher.zip';
    final localUpdateFilePath = '$currentDir/$updateFileName';
    final batFilePath = '$currentDir/update.bat';
    final versionFilePath = '$currentDir/version.txt';

    // Delete the update file if it exists
    final updateFile = File(localUpdateFilePath);
    if (await updateFile.exists()) {
      await updateFile.delete();
    }

    // Delete the .bat file if it exists
    final batFile = File(batFilePath);
    if (await batFile.exists()) {
      await batFile.delete();
    }

    // Delete the version file if it exists
    final versionFile = File(versionFilePath);
    if (await versionFile.exists()) {
      await versionFile.delete();
    }
  }
}
