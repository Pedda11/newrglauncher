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
}