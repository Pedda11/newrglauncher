import 'dart:io';
import 'package:ftpconnect/ftpconnect.dart';

class UpdateService {

  void updateApp() async {
    // Get the current directory path
    final currentDir = Directory.current.path;

    // FTP server details
    const ftpAddress = '144.76.163.80';
    const ftpUser = 'wow_launcher';
    const ftpPass = 'wow_launcher_01';
    const fileName = 'launcher.zip';
    final localFilePath = '$currentDir/$fileName';

    // Connect to FTP server and download the file
    FTPConnect ftpConnect = FTPConnect(ftpAddress, user: ftpUser, pass: ftpPass);
    await ftpConnect.connect();
    bool res = await ftpConnect.downloadFileWithRetry(fileName, File(localFilePath));
    await ftpConnect.disconnect();

    if (res) {
      // Path to the .bat file
      final batFilePath = '$currentDir/update.bat';

      // Content of the .bat file
      final batContent = '''
      @echo off
      taskkill /F /IM twodotnulllauncher.exe
      timeout /t 2 /nobreak
      del /F /Q "$currentDir\\twodotnulllauncher.exe"
      powershell -Command "Expand-Archive -Path '$currentDir\\$fileName' -DestinationPath '$currentDir\\' -Force"
      start "" "$currentDir\\twodotnulllauncher.exe"
      exit
      ''';

      // Create the .bat file
      final batFile = File(batFilePath);
      await batFile.writeAsString(batContent);

      // Execute the .bat file
      await Process.start('cmd.exe', ['/c', batFilePath]);
    } else {
      print('Failed to download the file from FTP server.');
    }
  }

  void removeUpdateFiles() {
    // Get the current directory path
    final currentDir = Directory.current.path;

    // Delete the .zip file
    final zipFile = File('$currentDir/launcher.zip');
    zipFile.deleteSync();

    // Delete the .bat file
    final batFile = File('$currentDir/update.bat');
    batFile.deleteSync();
  }
}