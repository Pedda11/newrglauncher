import 'dart:io';

class SettingsRepository {
  String? wowExecutableName;
  String? wowRootFolderPath;
  String? wowRealmFilePath;
  String? wowDataDirectory;
  String? wowBackupDirectoryPath;
  String? wowAddonsDirectoryPath;
  String? wowAccountsDirectoryPath;
  int secondsToWaitForGameToStart = 3;
}

extension SettingsRepositoryExtension on SettingsRepository {
  void fillWithExecutablePath(String executablePath) {
    wowExecutableName = executablePath.split(Platform.pathSeparator).last;
    wowRootFolderPath = executablePath.replaceAll(wowExecutableName!, '');
    wowBackupDirectoryPath = '${wowRootFolderPath!}Backup';
    wowAddonsDirectoryPath =
        '${wowRootFolderPath!}Interface${Platform.pathSeparator}AddOns';
    wowAccountsDirectoryPath =
        '${wowRootFolderPath!}WTF${Platform.pathSeparator}Account';
  }
}
