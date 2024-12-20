import 'dart:io';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateService {

  Future<void> updateApp() async {
    // Get the current directory path
    final currentDir = Directory.current.path;

    // FTP server details
    const ftpAddress = '144.76.163.80';
    const ftpUser = 'wow_launcher';
    const ftpPass = 'wow_launcher_01';
    const versionFileName = 'version.txt';
    const updateFileName = 'launcher.zip';
    final localVersionFilePath = '$currentDir/$versionFileName';
    final localUpdateFilePath = '$currentDir/$updateFileName';

    // Connect to FTP server and download the version file
    FTPConnect ftpConnect = FTPConnect(ftpAddress, user: ftpUser, pass: ftpPass);
    await ftpConnect.connect();
    bool versionFileDownloaded = await ftpConnect.downloadFileWithRetry(versionFileName, File(localVersionFilePath));
    await ftpConnect.disconnect();

    if (versionFileDownloaded) {
      // Read the version from the downloaded file
      String latestVersion = await File(localVersionFilePath).readAsString();

      // Get the current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Compare versions
      if (latestVersion.trim() != currentVersion.trim()) {
        // Connect to FTP server and download the update file
        await ftpConnect.connect();
        bool updateFileDownloaded = await ftpConnect.downloadFileWithRetry(updateFileName, File(localUpdateFilePath));
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
          del /F /Q "$currentDir\\$updateFileName"
          del /F /Q "$currentDir\\update.bat"
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
      } else {
        print('No update needed. The application is up to date.');
      }
    } else {
      print('Failed to download the version file from FTP server.');
    }
  }
}