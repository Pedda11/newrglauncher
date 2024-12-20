import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  static const String _accounts = 'accounts';
  static const String _chars = 'chars';
  final SharedPreferencesAsync _preferences;

  PreferencesRepository({required SharedPreferencesAsync preferences})
      : _preferences = preferences;

  Future setAccounts(List<String> accounts) async =>
      _preferences.setStringList(_accounts, accounts);

  Future<List<String>?> getAccounts() => _preferences.getStringList(_accounts);

  Future deleteAccounts() => _preferences.remove(_accounts);

  Future setWowPath(String wowPath) async =>
      _preferences.setString('wowPath', wowPath);

  Future setDataDirectory(String dataDirectory) async =>
      _preferences.setString('dataDirectory', dataDirectory);

  Future<String?> getWowPath() => _preferences.getString('wowPath');

  Future<String?> getDataDirectoryPath() =>
      _preferences.getString('dataDirectory');

  Future deleteSettings() => _preferences.remove('wowPath');

  Future delDataDirectoryPath() => _preferences.remove('dataDirectory');
}
