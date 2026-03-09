import 'dart:io';

class SettingsRepository {
  String? wowExecutableName;
  String? wowRootFolderPath;
  String? wowRealmListFilePath;
  String? wowDataDirectoryPath;
  String? wowBackupDirectoryPath;
  String? wowAddonsDirectoryPath;
  String? wowAccountsDirectoryPath;
  int? secondsToWaitForGameToStart;

  List<String> drives = [];
}

extension SettingsRepositoryExtension on SettingsRepository {
  void fillWithExecutablePath(String? executablePath) {
    if (executablePath == null) {
      return;
    }
    wowExecutableName = executablePath.split(Platform.pathSeparator).last;
    wowRootFolderPath = executablePath.replaceAll(wowExecutableName!, '');
    wowBackupDirectoryPath = '${wowRootFolderPath!}Backup';
    wowAddonsDirectoryPath =
        '${wowRootFolderPath!}Interface${Platform.pathSeparator}AddOns';
    wowAccountsDirectoryPath =
        '${wowRootFolderPath!}WTF${Platform.pathSeparator}Account';
  }
}
