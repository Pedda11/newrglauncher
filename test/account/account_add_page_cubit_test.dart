import 'package:twodotnulllauncher/repository/credential_repository.dart';
import 'package:twodotnulllauncher/repository/i_preferences_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twodotnulllauncher/data/account.dart';
import 'package:twodotnulllauncher/repository/main_repository.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_add/cubit/account_add_page_cubit.dart';

class FakePreferencesRepository implements IPreferencesRepository {
  List<String>? savedAccounts;

  @override
  Future setAccounts(List<String> accounts) async {
    savedAccounts = accounts;
  }
}

class FakeCredentialRepository extends CredentialRepository {
  final Map<String, String> passwords = {};
  final Map<String, String> totpSecrets = {};

  @override
  Future<void> savePassword(String accountUuid, String password) async {
    passwords[accountUuid] = password;
  }

  @override
  Future<void> saveTotpSecret(String accountUuid, String secret) async {
    totpSecrets[accountUuid] = secret;
  }

  @override
  Future<String?> readPassword(String accountUuid) async {
    return passwords[accountUuid];
  }

  @override
  Future<String?> readTotpSecret(String accountUuid) async {
    return totpSecrets[accountUuid];
  }

  @override
  Future<void> deleteTotpSecret(String accountUuid) async {
    totpSecrets.remove(accountUuid);
  }
}

void main() {
  test('addAccount stores password, TOTP and updates repositories', () async {
    /// Arrange
    final mainRepository = MainRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    final cubit = AccountAddPageCubit(
      mainRepository: mainRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    final account = Account(
      accId: 0,
      uniqueId: '',
      listName: 'Test',
      accountName: 'TestAccount',
      accountRealm: 'realm',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: true,
    );

    const password = '123456';
    const totpSecret = 'JBSWY3DPEHPK3PXP';

    /// Act
    await cubit.addAccount(account, password, totpSecret);

    /// Assert

    // Account wurde hinzugefügt
    expect(mainRepository.accountList.length, 1);

    final savedAccount = mainRepository.accountList.first;

    // Passwort gespeichert
    expect(
      credentialRepository.passwords[savedAccount.uniqueId],
      equals(password),
    );

    // TOTP gespeichert
    expect(
      credentialRepository.totpSecrets[savedAccount.uniqueId],
      equals(totpSecret),
    );

    // Preferences geschrieben
    expect(preferencesRepository.savedAccounts, isNotNull);
    expect(preferencesRepository.savedAccounts!.length, 1);
  });

  test('editAccount enables TOTP and stores secret', () async {
    /// Arrange
    final mainRepository = MainRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    final cubit = AccountAddPageCubit(
      mainRepository: mainRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    final account = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'Test',
      accountName: 'TestAccount',
      accountRealm: 'realm',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: false,
    );

    mainRepository.accountList.add(account);

    /// vorher kein TOTP gespeichert
    expect(
      credentialRepository.totpSecrets[account.uniqueId],
      isNull,
    );

    /// Act
    final updatedAccount = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'Test',
      accountName: 'TestAccount',
      accountRealm: 'realm',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: true,
    );

    const newPassword = '123456';
    const newTotp = 'JBSWY3DPEHPK3PXP';

    await cubit.editAccount(updatedAccount, newPassword, newTotp);

    /// Assert

    // TOTP wurde gespeichert
    expect(
      credentialRepository.totpSecrets[account.uniqueId],
      equals(newTotp),
    );

    // Account wurde aktualisiert
    expect(mainRepository.accountList.first.isTotpEnabled, isTrue);

    // Preferences wurden geschrieben
    expect(preferencesRepository.savedAccounts, isNotNull);
  });

  test('editAccount disables TOTP and deletes stored secret', () async {
    /// Arrange
    final mainRepository = MainRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    final cubit = AccountAddPageCubit(
      mainRepository: mainRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    final account = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'Test',
      accountName: 'TestAccount',
      accountRealm: 'realm',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: true,
    );

    mainRepository.accountList.add(account);
    credentialRepository.totpSecrets[account.uniqueId] = 'JBSWY3DPEHPK3PXP';

    /// sanity check
    expect(
      credentialRepository.totpSecrets[account.uniqueId],
      isNotNull,
    );

    /// Act
    final updatedAccount = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'Test',
      accountName: 'TestAccount',
      accountRealm: 'realm',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: false,
    );

    await cubit.editAccount(updatedAccount, '123456', null);

    /// Assert

    // Secret wurde gelöscht
    expect(
      credentialRepository.totpSecrets[account.uniqueId],
      isNull,
    );

    // Account wurde aktualisiert
    expect(mainRepository.accountList.first.isTotpEnabled, isFalse);

    // Preferences wurden geschrieben
    expect(preferencesRepository.savedAccounts, isNotNull);
  });

  test('editAccount updates existing TOTP secret', () async {
    /// Arrange
    final mainRepository = MainRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    final cubit = AccountAddPageCubit(
      mainRepository: mainRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    final account = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'Test',
      accountName: 'TestAccount',
      accountRealm: 'realm',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: true,
    );

    mainRepository.accountList.add(account);
    credentialRepository.totpSecrets[account.uniqueId] = 'OLDSECRET123';

    /// sanity check
    expect(
      credentialRepository.totpSecrets[account.uniqueId],
      equals('OLDSECRET123'),
    );

    /// Act
    final updatedAccount = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'Test',
      accountName: 'TestAccount',
      accountRealm: 'realm',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: true,
    );

    const newTotpSecret = 'JBSWY3DPEHPK3PXP';

    await cubit.editAccount(updatedAccount, '123456', newTotpSecret);

    /// Assert

    // Secret wurde überschrieben
    expect(
      credentialRepository.totpSecrets[account.uniqueId],
      equals(newTotpSecret),
    );

    // Account bleibt TOTP-enabled
    expect(mainRepository.accountList.first.isTotpEnabled, isTrue);

    // Preferences wurden geschrieben
    expect(preferencesRepository.savedAccounts, isNotNull);
  });
}
