import '../data/account.dart';
import 'settings_repository.dart';

class MainRepository {
  List<Account>? accountList;
  String? pin;
  SettingsRepository settingsRepository = SettingsRepository();
}
