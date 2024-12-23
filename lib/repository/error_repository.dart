import 'dart:io';
import 'package:ftpconnect/ftpconnect.dart';

class ErrorRepository {
  // send error to server via ftp
  Future<bool> sendErrorToServer(
      {required String errorMessage,
      required String errorOnPosition,
      required String errorDateTime}) async {
    // Get the current directory path
    final currentDir = Directory.current.path;

    // FTP server details
    const ftpAddress = '144.76.163.80';
    const ftpUser = 'wow_launcher';
    const ftpPass = 'wow_launcher_01';
    final formattedDateTime =
        errorDateTime.replaceAll(':', '-').replaceAll(' ', '_');
    final errorFileName = '$errorOnPosition-$formattedDateTime.txt';
    final localErrorFilePath = '$currentDir/$errorFileName';

    try {
      // Create the error file
      final errorFile = File(localErrorFilePath);
      await errorFile.writeAsString(
          'Error Message: $errorMessage\nError Position: $errorOnPosition\nError DateTime: $errorDateTime');

      // Connect to FTP server and upload the error file
      FTPConnect ftpConnect =
          FTPConnect(ftpAddress, user: ftpUser, pass: ftpPass);
      await ftpConnect.connect();
      bool errorFileUploaded = await ftpConnect.uploadFileWithRetry(errorFile);
      await ftpConnect.disconnect();

      if (errorFileUploaded) {
        print('Error file uploaded successfully.');
        return true;
      } else {
        print('Failed to upload the error file to FTP server.');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
