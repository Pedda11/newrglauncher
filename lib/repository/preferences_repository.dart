import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  static const String _debugPrefix = kDebugMode ? 'debug_' : '';

  static const String _accounts = '${_debugPrefix}accounts';
  static const String _eula = '${_debugPrefix}eula';
  static const String _wowPath = '${_debugPrefix}wowPath';
  static const String _dataDirectory = '${_debugPrefix}dataDirectory';
  static const String _waitTillGameStarts = '${_debugPrefix}waitTillGameStarts';

  final SharedPreferencesAsync _preferences;

  PreferencesRepository({required SharedPreferencesAsync preferences})
      : _preferences = preferences;

  //setter
  Future setEula(bool accepted) async => _preferences.setBool(_eula, accepted);

  Future setAccounts(List<String> accounts) async =>
      _preferences.setStringList(_accounts, accounts);

  Future setWaitTillGameStarts(int seconds) async =>
      _preferences.setInt(_waitTillGameStarts, seconds);

  Future setWowPath(String wowPath) async =>
      _preferences.setString(_wowPath, wowPath);

  Future setDataDirectory(String dataDirectory) async =>
      _preferences.setString(_dataDirectory, dataDirectory);

  //getter
  Future<List<String>?> getAccounts() => _preferences.getStringList(_accounts);

  Future<bool?> getEula() => _preferences.getBool(_eula);

  Future<String?> getWowPath() => _preferences.getString(_wowPath);

  Future<String?> getDataDirectoryPath() =>
      _preferences.getString(_dataDirectory);

  Future<int?> getWaitTillGameStarts() =>
      _preferences.getInt(_waitTillGameStarts);

  //deleter
  Future deleteAccounts() => _preferences.remove(_accounts);

  Future deleteSettings() => _preferences.remove(_wowPath);

  Future delDataDirectoryPath() => _preferences.remove(_dataDirectory);

  Future deleteAll() => _preferences.clear();
}
