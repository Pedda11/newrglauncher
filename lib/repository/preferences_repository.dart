import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  static const String _accounts = 'accounts';
  static const String _wowPath = 'wowPath';
  static const String _dataDirectory = 'dataDirectory';
  static const String _waitTillGameStarts = 'waitTillGameStarts';

  final SharedPreferencesAsync _preferences;

  PreferencesRepository({required SharedPreferencesAsync preferences})
      : _preferences = preferences;

  Future setAccounts(List<String> accounts) async =>
      _preferences.setStringList(_accounts, accounts);

  Future<List<String>?> getAccounts() => _preferences.getStringList(_accounts);

  Future deleteAccounts() => _preferences.remove(_accounts);

  Future setWowPath(String wowPath) async =>
      _preferences.setString(_wowPath, wowPath);

  Future setDataDirectory(String dataDirectory) async =>
      _preferences.setString(_dataDirectory, dataDirectory);

  Future<String?> getWowPath() => _preferences.getString(_wowPath);

  Future<String?> getDataDirectoryPath() =>
      _preferences.getString(_dataDirectory);

  Future deleteSettings() => _preferences.remove(_wowPath);

  Future delDataDirectoryPath() => _preferences.remove(_dataDirectory);

  Future setWaitTillGameStarts(int seconds) async =>
      _preferences.setInt(_waitTillGameStarts, seconds);

  Future<int?> getWaitTillGameStarts() =>
      _preferences.getInt(_waitTillGameStarts);
}
