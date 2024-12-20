import 'package:shared_preferences/shared_preferences.dart';

class SettingsPreferences {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setWowPath(String wowPath) async =>
      _preferences.setString('wowPath', wowPath);
  static Future setDataDirectory(String dataDirectory) async =>
      _preferences.setString('dataDirectory', dataDirectory);

  static String? getWowPath() => _preferences.getString('wowPath');
  static String? getDataDirectoryPath() =>
      _preferences.getString('dataDirectory');

  static Future deleteSettings() => _preferences.remove('wowPath');
  static Future delDataDirectoryPath() => _preferences.remove('dataDirectory');
}
