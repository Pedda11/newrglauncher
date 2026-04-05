import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twodotnulllauncher/data/account.dart';
import 'package:twodotnulllauncher/localization/generated/l10n.dart';
import 'package:twodotnulllauncher/repository/credential_repository.dart';
import 'package:twodotnulllauncher/repository/i_preferences_repository.dart';
import 'package:twodotnulllauncher/repository/main_repository.dart';
import 'package:twodotnulllauncher/repository/preferences_repository.dart';
import 'package:twodotnulllauncher/repository/settings_repository.dart';
import 'package:twodotnulllauncher/screens/account/cubit/account_cubit/account_screen_cubit.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_add/account_add_page.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_add/cubit/account_add_page_cubit.dart';
import 'package:twodotnulllauncher/services/totp/totp_service.dart';

Future<void> pumpAccountAddPage({
  required WidgetTester tester,
  required MainRepository mainRepository,
  required SettingsRepository settingsRepository,
  required FakePreferencesRepository preferencesRepository,
  required FakeCredentialRepository credentialRepository,
}) async {
  await tester.binding.setSurfaceSize(const Size(1400, 900));
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MainRepository>.value(value: mainRepository),
        RepositoryProvider<SettingsRepository>.value(value: settingsRepository),
        RepositoryProvider<CredentialRepository>.value(
            value: credentialRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AccountAddPageCubit(
              mainRepository: mainRepository,
              preferencesRepository: preferencesRepository,
              credentialRepository: credentialRepository,
            ),
          ),
          BlocProvider(
            create: (_) => AccountScreenCubit(
              mainRepository: mainRepository,
              settingsRepository: settingsRepository,
              preferencesRepository: PreferencesRepository(
                preferences: SharedPreferencesAsync(),
              ),
            ),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          localizationsDelegates: const [
            Localize.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('de', ''),
          ],
          home: AccountAddPage(
            credentialRepository: credentialRepository,
          ),
        ),
      ),
    ),
  );

  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));

  dynamic exception;
  while ((exception = tester.takeException()) != null) {
    // ignore: avoid_print
    print('TEST EXCEPTION: $exception');
  }

  expect(find.byType(AccountAddPage), findsOneWidget);
}

ElevatedButton getSaveButton(WidgetTester tester) {
  final finder = find.byKey(const Key('account_add_save_button'));
  expect(finder, findsOneWidget);
  return tester.widget<ElevatedButton>(finder);
}

class FakeCredentialRepository extends CredentialRepository {
  final Map<String, String> passwords = {};
  final Map<String, String> totpSecrets = {};

  @override
  Future<void> savePassword(String accountUuid, String password) async {
    passwords[accountUuid] = password;
  }

  @override
  Future<String?> readPassword(String accountUuid) async {
    return passwords[accountUuid];
  }

  @override
  Future<void> saveTotpSecret(String accountUuid, String secret) async {
    totpSecrets[accountUuid] = secret;
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

class FakePreferencesRepository implements IPreferencesRepository {
  List<String>? savedAccounts;

  @override
  Future setAccounts(List<String> accounts) async {
    savedAccounts = accounts;
  }
}

void main() {
  testWidgets(
    'save button is disabled after TOTP secret change and re-enabled after valid check',
    (tester) async {
      /// Arrange
      final mainRepository = MainRepository();
      final settingsRepository = SettingsRepository();
      final preferencesRepository = FakePreferencesRepository();
      final credentialRepository = FakeCredentialRepository();

      final existingAccount = Account(
        accId: 1,
        uniqueId: 'test-id',
        listName: 'My List',
        accountName: 'My Account',
        accountRealm: 'logon.rising-gods.de',
        accChars: [],
        includeInGoldTrend: false,
        isTotpEnabled: true,
      );

      mainRepository.account = existingAccount;
      credentialRepository.passwords['test-id'] = 'mypassword';
      credentialRepository.totpSecrets['test-id'] = 'JBSWY3DPEHPK3PXP';

      await tester.binding.setSurfaceSize(const Size(1400, 900));
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<MainRepository>.value(value: mainRepository),
            RepositoryProvider<SettingsRepository>.value(
                value: settingsRepository),
            RepositoryProvider<CredentialRepository>.value(
                value: credentialRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AccountAddPageCubit(
                  mainRepository: mainRepository,
                  preferencesRepository: preferencesRepository,
                  credentialRepository: credentialRepository,
                ),
              ),
            ],
            child: MaterialApp(
              locale: const Locale('de'),
              localizationsDelegates: const [
                Localize.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''),
                Locale('de', ''),
              ],
              home: AccountAddPage(
                credentialRepository: credentialRepository,
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      dynamic exception;
      while ((exception = tester.takeException()) != null) {
        // ignore: avoid_print
        print('TEST EXCEPTION: $exception');
      }

      expect(find.byType(AccountAddPage), findsOneWidget);

      final saveButtonFinder = find.byKey(const Key('account_add_save_button'));
      expect(saveButtonFinder, findsOneWidget);

      /// Initially enabled
      var saveButton = tester.widget<ElevatedButton>(saveButtonFinder);
      expect(saveButton.onPressed, isNotNull);

      /// Change TOTP secret
      await tester.enterText(
        find.byKey(const Key('account_add_totp_secret')),
        'NB2W45DFOIZA====',
      );
      await tester.pump();

      saveButton = tester.widget<ElevatedButton>(saveButtonFinder);
      expect(saveButton.onPressed, isNull);

      /// Enter valid auth code
      final totpService = TotpService();
      final validCode = totpService.generateCode(
        secret: 'NB2W45DFOIZA====',
      );

      await tester.enterText(
        find.byKey(const Key('account_add_totp_code')),
        validCode,
      );

      await tester.tap(
        find.byKey(const Key('account_add_totp_check_button')),
      );
      await tester.pump();

      /// Should be enabled again
      saveButton = tester.widget<ElevatedButton>(saveButtonFinder);
      expect(saveButton.onPressed, isNotNull);
    },
  );

  testWidgets('save button is disabled when list name is empty',
      (tester) async {
    final mainRepository = MainRepository();
    final settingsRepository = SettingsRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    final existingAccount = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'My List',
      accountName: 'My Account',
      accountRealm: 'logon.rising-gods.de',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: false,
    );

    mainRepository.account = existingAccount;
    credentialRepository.passwords['test-id'] = 'mypassword';

    await pumpAccountAddPage(
      tester: tester,
      mainRepository: mainRepository,
      settingsRepository: settingsRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    expect(getSaveButton(tester).onPressed, isNotNull);

    await tester.enterText(
      find.byKey(const Key('account_add_list_name')),
      '',
    );
    await tester.pump();

    expect(getSaveButton(tester).onPressed, isNull);
  });

  testWidgets('save button is disabled when account name is empty',
      (tester) async {
    final mainRepository = MainRepository();
    final settingsRepository = SettingsRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    final existingAccount = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'My List',
      accountName: 'My Account',
      accountRealm: 'logon.rising-gods.de',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: false,
    );

    mainRepository.account = existingAccount;
    credentialRepository.passwords['test-id'] = 'mypassword';

    await pumpAccountAddPage(
      tester: tester,
      mainRepository: mainRepository,
      settingsRepository: settingsRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    expect(getSaveButton(tester).onPressed, isNotNull);

    await tester.enterText(
      find.byKey(const Key('account_add_account_name')),
      '',
    );
    await tester.pump();

    expect(getSaveButton(tester).onPressed, isNull);
  });

  testWidgets('save button is disabled when password is empty', (tester) async {
    final mainRepository = MainRepository();
    final settingsRepository = SettingsRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    final existingAccount = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'My List',
      accountName: 'My Account',
      accountRealm: 'logon.rising-gods.de',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: false,
    );

    mainRepository.account = existingAccount;
    credentialRepository.passwords['test-id'] = 'mypassword';

    await pumpAccountAddPage(
      tester: tester,
      mainRepository: mainRepository,
      settingsRepository: settingsRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    expect(getSaveButton(tester).onPressed, isNotNull);

    await tester.enterText(
      find.byKey(const Key('account_add_password')),
      '',
    );
    await tester.pump();

    expect(getSaveButton(tester).onPressed, isNull);
  });

  testWidgets(
      'save button is disabled when TOTP is enabled and secret is empty',
      (tester) async {
    final mainRepository = MainRepository();
    final settingsRepository = SettingsRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    final existingAccount = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'My List',
      accountName: 'My Account',
      accountRealm: 'logon.rising-gods.de',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: true,
    );

    mainRepository.account = existingAccount;
    credentialRepository.passwords['test-id'] = 'mypassword';
    credentialRepository.totpSecrets['test-id'] = 'JBSWY3DPEHPK3PXP';

    await pumpAccountAddPage(
      tester: tester,
      mainRepository: mainRepository,
      settingsRepository: settingsRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    expect(getSaveButton(tester).onPressed, isNotNull);

    await tester.enterText(
      find.byKey(const Key('account_add_totp_secret')),
      '',
    );
    await tester.pump();

    expect(getSaveButton(tester).onPressed, isNull);
  });

  testWidgets(
      'save button stays disabled when TOTP secret changed but not validated',
      (tester) async {
    final mainRepository = MainRepository();
    final settingsRepository = SettingsRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    final existingAccount = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'My List',
      accountName: 'My Account',
      accountRealm: 'logon.rising-gods.de',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: true,
    );

    mainRepository.account = existingAccount;
    credentialRepository.passwords['test-id'] = 'mypassword';
    credentialRepository.totpSecrets['test-id'] = 'JBSWY3DPEHPK3PXP';

    await pumpAccountAddPage(
      tester: tester,
      mainRepository: mainRepository,
      settingsRepository: settingsRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    expect(getSaveButton(tester).onPressed, isNotNull);

    await tester.enterText(
      find.byKey(const Key('account_add_totp_secret')),
      'NB2W45DFOIZA====',
    );
    await tester.pump();

    expect(getSaveButton(tester).onPressed, isNull);
  });

  testWidgets(
      'save button is enabled when TOTP is disabled and required fields are filled',
      (tester) async {
    final mainRepository = MainRepository();
    final settingsRepository = SettingsRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    final existingAccount = Account(
      accId: 1,
      uniqueId: 'test-id',
      listName: 'My List',
      accountName: 'My Account',
      accountRealm: 'logon.rising-gods.de',
      accChars: [],
      includeInGoldTrend: false,
      isTotpEnabled: false,
    );

    mainRepository.account = existingAccount;
    credentialRepository.passwords['test-id'] = 'mypassword';

    await pumpAccountAddPage(
      tester: tester,
      mainRepository: mainRepository,
      settingsRepository: settingsRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    expect(getSaveButton(tester).onPressed, isNotNull);
  });

  testWidgets(
      'save button is disabled for new account when all fields are empty',
      (tester) async {
    final mainRepository = MainRepository();
    final settingsRepository = SettingsRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    await pumpAccountAddPage(
      tester: tester,
      mainRepository: mainRepository,
      settingsRepository: settingsRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    expect(getSaveButton(tester).onPressed, isNull);
  });

  testWidgets(
      'save button is enabled for new account when required fields are filled and TOTP is disabled',
      (tester) async {
    final mainRepository = MainRepository();
    final settingsRepository = SettingsRepository();
    final preferencesRepository = FakePreferencesRepository();
    final credentialRepository = FakeCredentialRepository();

    await pumpAccountAddPage(
      tester: tester,
      mainRepository: mainRepository,
      settingsRepository: settingsRepository,
      preferencesRepository: preferencesRepository,
      credentialRepository: credentialRepository,
    );

    expect(getSaveButton(tester).onPressed, isNull);

    await tester.enterText(
      find.byKey(const Key('account_add_list_name')),
      'My List',
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('account_add_account_name')),
      'My Account',
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('account_add_password')),
      'mypassword',
    );
    await tester.pump();

    expect(getSaveButton(tester).onPressed, isNotNull);
  });
}
