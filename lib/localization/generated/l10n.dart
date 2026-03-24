// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Localize {
  Localize();

  static Localize? _current;

  static Localize get current {
    assert(
      _current != null,
      'No instance of Localize was loaded. Try to initialize the Localize delegate before accessing Localize.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Localize> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Localize();
      Localize._current = instance;

      return instance;
    });
  }

  static Localize of(BuildContext context) {
    final instance = Localize.maybeOf(context);
    assert(
      instance != null,
      'No instance of Localize present in the widget tree. Did you add Localize.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static Localize? maybeOf(BuildContext context) {
    return Localizations.of<Localize>(context, Localize);
  }

  /// `WOW-Launcher`
  String get appTitle {
    return Intl.message('WOW-Launcher', name: 'appTitle', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Ja`
  String get yes {
    return Intl.message('Ja', name: 'yes', desc: '', args: []);
  }

  /// `Nein`
  String get no {
    return Intl.message('Nein', name: 'no', desc: '', args: []);
  }

  /// `Speichern`
  String get save {
    return Intl.message('Speichern', name: 'save', desc: '', args: []);
  }

  /// `Zurück`
  String get back {
    return Intl.message('Zurück', name: 'back', desc: '', args: []);
  }

  /// `Fehler`
  String get error {
    return Intl.message('Fehler', name: 'error', desc: '', args: []);
  }

  /// `Bestätigen`
  String get accept {
    return Intl.message('Bestätigen', name: 'accept', desc: '', args: []);
  }

  /// `Ablehnen`
  String get decline {
    return Intl.message('Ablehnen', name: 'decline', desc: '', args: []);
  }

  /// `Eula`
  String get eulaLabel {
    return Intl.message('Eula', name: 'eulaLabel', desc: '', args: []);
  }

  /// `Ich habe die Eula gelesen und akzeptiert`
  String get eulaAcceptText {
    return Intl.message(
      'Ich habe die Eula gelesen und akzeptiert',
      name: 'eulaAcceptText',
      desc: '',
      args: [],
    );
  }

  /// `Folgender Fehler ist aufgetreten. Der Fehler wird automatisch reported. Bitte versuchen Sie es später erneut.`
  String get errorHandlingContent {
    return Intl.message(
      'Folgender Fehler ist aufgetreten. Der Fehler wird automatisch reported. Bitte versuchen Sie es später erneut.',
      name: 'errorHandlingContent',
      desc: '',
      args: [],
    );
  }

  /// `Prüfe auf Updates...`
  String get updateScreenUpdateCheck {
    return Intl.message(
      'Prüfe auf Updates...',
      name: 'updateScreenUpdateCheck',
      desc: '',
      args: [],
    );
  }

  /// `U P D A T E   V E R F Ü G B A R`
  String get updateScreenUpdateFound {
    return Intl.message(
      'U P D A T E   V E R F Ü G B A R',
      name: 'updateScreenUpdateFound',
      desc: '',
      args: [],
    );
  }

  /// `Möchten Sie das Update jetzt herunterladen und installieren?`
  String get updateScreenUpdateQuestion {
    return Intl.message(
      'Möchten Sie das Update jetzt herunterladen und installieren?',
      name: 'updateScreenUpdateQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Update wird heruntergeladen und installiert!`
  String get updateScreenUpdating {
    return Intl.message(
      'Update wird heruntergeladen und installiert!',
      name: 'updateScreenUpdating',
      desc: '',
      args: [],
    );
  }

  /// `M E N Ü`
  String get menuTitle {
    return Intl.message('M E N Ü', name: 'menuTitle', desc: '', args: []);
  }

  /// `Einstellungen`
  String get menuItemSettings {
    return Intl.message(
      'Einstellungen',
      name: 'menuItemSettings',
      desc: '',
      args: [],
    );
  }

  /// `Meine Accounts`
  String get accountScreenTitle {
    return Intl.message(
      'Meine Accounts',
      name: 'accountScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Keine Accounts gespeichert`
  String get accountScreenNoAccounts {
    return Intl.message(
      'Keine Accounts gespeichert',
      name: 'accountScreenNoAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Keine Daten vorhanden`
  String get accountScreenNoData {
    return Intl.message(
      'Keine Daten vorhanden',
      name: 'accountScreenNoData',
      desc: '',
      args: [],
    );
  }

  /// `Account hinzufügen`
  String get accountAddPageTitle {
    return Intl.message(
      'Account hinzufügen',
      name: 'accountAddPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `N e u e r   A c c o u n t`
  String get accountAddPageNewAccount {
    return Intl.message(
      'N e u e r   A c c o u n t',
      name: 'accountAddPageNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Listen Name`
  String get accountAddPageListNameLabel {
    return Intl.message(
      'Listen Name',
      name: 'accountAddPageListNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Account Name`
  String get accountAddPageAccountNameLabel {
    return Intl.message(
      'Account Name',
      name: 'accountAddPageAccountNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Account Passwort`
  String get accountAddPagePasswordLabel {
    return Intl.message(
      'Account Passwort',
      name: 'accountAddPagePasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Realm/Logonserver`
  String get accountAddPageRealmLabel {
    return Intl.message(
      'Realm/Logonserver',
      name: 'accountAddPageRealmLabel',
      desc: '',
      args: [],
    );
  }

  /// `Account Liste`
  String get accountListPageTitle {
    return Intl.message(
      'Account Liste',
      name: 'accountListPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Account hinzufügen`
  String get accountListPageAddAccountBtn {
    return Intl.message(
      'Account hinzufügen',
      name: 'accountListPageAddAccountBtn',
      desc: '',
      args: [],
    );
  }

  /// `E I N S T E L L U N G E N`
  String get settingsScreenTitle {
    return Intl.message(
      'E I N S T E L L U N G E N',
      name: 'settingsScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `WoW-Speicherort`
  String get settingsScreenWowPathLabel {
    return Intl.message(
      'WoW-Speicherort',
      name: 'settingsScreenWowPathLabel',
      desc: '',
      args: [],
    );
  }

  /// `WoW Pfad noch nicht gesetzt`
  String get settingsScreenWowPathMissingLabel {
    return Intl.message(
      'WoW Pfad noch nicht gesetzt',
      name: 'settingsScreenWowPathMissingLabel',
      desc: '',
      args: [],
    );
  }

  /// `Geschätzte Zeit bis zum Spielstart fehlt`
  String get settingsScreenTimeTillGameStartMissingLabel {
    return Intl.message(
      'Geschätzte Zeit bis zum Spielstart fehlt',
      name: 'settingsScreenTimeTillGameStartMissingLabel',
      desc: '',
      args: [],
    );
  }

  /// `Scanne dein System nach wow.exe`
  String get settingsScreenWowPathScanBtn {
    return Intl.message(
      'Scanne dein System nach wow.exe',
      name: 'settingsScreenWowPathScanBtn',
      desc: '',
      args: [],
    );
  }

  /// `Scanne nach Laufwerken...`
  String get settingsScreenScanningForDrives {
    return Intl.message(
      'Scanne nach Laufwerken...',
      name: 'settingsScreenScanningForDrives',
      desc: '',
      args: [],
    );
  }

  /// `Auf Laufwerk konnte nicht zugegriffen werden`
  String get settingsScreenDriveAccessError {
    return Intl.message(
      'Auf Laufwerk konnte nicht zugegriffen werden',
      name: 'settingsScreenDriveAccessError',
      desc: '',
      args: [],
    );
  }

  /// `<- Scanne deine Laufwerke nach wow.exe und wähle sie aus der angezeigten Liste aus.`
  String get settingsScreenWowPathScanBtnHint {
    return Intl.message(
      '<- Scanne deine Laufwerke nach wow.exe und wähle sie aus der angezeigten Liste aus.',
      name: 'settingsScreenWowPathScanBtnHint',
      desc: '',
      args: [],
    );
  }

  /// `<- Oder wählen Sie die Anwendung manuell aus einem der verfügbaren Laufwerke aus.`
  String get settingsScreenWowPathDrivesBtnHint {
    return Intl.message(
      '<- Oder wählen Sie die Anwendung manuell aus einem der verfügbaren Laufwerke aus.',
      name: 'settingsScreenWowPathDrivesBtnHint',
      desc: '',
      args: [],
    );
  }

  /// `Setze den WoW Pfad durch Scannen deiner Laufwerke oder durch manuelles Auswählen der Datei.`
  String get settingsScreenSetWowPathLabel {
    return Intl.message(
      'Setze den WoW Pfad durch Scannen deiner Laufwerke oder durch manuelles Auswählen der Datei.',
      name: 'settingsScreenSetWowPathLabel',
      desc: '',
      args: [],
    );
  }

  /// `Laufwerk nicht verfügbar`
  String get settingsScreenSetWowPathManuallyDriveException {
    return Intl.message(
      'Laufwerk nicht verfügbar',
      name: 'settingsScreenSetWowPathManuallyDriveException',
      desc: '',
      args: [],
    );
  }

  /// `Wähle deine WoW Anwendung`
  String get settingsScreenWowExeFilePickerLabel {
    return Intl.message(
      'Wähle deine WoW Anwendung',
      name: 'settingsScreenWowExeFilePickerLabel',
      desc: '',
      args: [],
    );
  }

  /// `Wähle deinen Data Ordner`
  String get settingsScreenWowDataPathLabel {
    return Intl.message(
      'Wähle deinen Data Ordner',
      name: 'settingsScreenWowDataPathLabel',
      desc: '',
      args: [],
    );
  }

  /// `Found the following wow.exe files.`
  String get settingsScreenFoundWowExesLabel {
    return Intl.message(
      'Found the following wow.exe files.',
      name: 'settingsScreenFoundWowExesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Spielst du WoW vorzugsweise auf Deutsch oder Englisch? Wähle den Data Ordner entsprechend deiner Sprache aus.`
  String get settingsScreenWowDataPathHint {
    return Intl.message(
      'Spielst du WoW vorzugsweise auf Deutsch oder Englisch? Wähle den Data Ordner entsprechend deiner Sprache aus.',
      name: 'settingsScreenWowDataPathHint',
      desc: '',
      args: [],
    );
  }

  /// `Geschätzte Zeit, bis der Launcher die Anmeldedaten eingeben kann.`
  String get settingsScreenTimeTillGameStartLabel {
    return Intl.message(
      'Geschätzte Zeit, bis der Launcher die Anmeldedaten eingeben kann.',
      name: 'settingsScreenTimeTillGameStartLabel',
      desc: '',
      args: [],
    );
  }

  /// `Scan abbrechen`
  String get settingsScreenCancelWowScanLabel {
    return Intl.message(
      'Scan abbrechen',
      name: 'settingsScreenCancelWowScanLabel',
      desc: '',
      args: [],
    );
  }

  /// `Sekunden`
  String get settingsScreenTimeTillGameStartType {
    return Intl.message(
      'Sekunden',
      name: 'settingsScreenTimeTillGameStartType',
      desc: '',
      args: [],
    );
  }

  /// `Noch nicht alle Einstellungen gesetzt!`
  String get settingsScreenNotAllSet {
    return Intl.message(
      'Noch nicht alle Einstellungen gesetzt!',
      name: 'settingsScreenNotAllSet',
      desc: '',
      args: [],
    );
  }

  /// `gescannte Ordner: `
  String get settingsScreenScannedFolders {
    return Intl.message(
      'gescannte Ordner: ',
      name: 'settingsScreenScannedFolders',
      desc: '',
      args: [],
    );
  }

  /// `gescannte Dateien: `
  String get settingsScreenScannedFiles {
    return Intl.message(
      'gescannte Dateien: ',
      name: 'settingsScreenScannedFiles',
      desc: '',
      args: [],
    );
  }

  /// `Name: `
  String get accountDataCardNameLabel {
    return Intl.message(
      'Name: ',
      name: 'accountDataCardNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Gilde: `
  String get accountDataCardGuildLabel {
    return Intl.message(
      'Gilde: ',
      name: 'accountDataCardGuildLabel',
      desc: '',
      args: [],
    );
  }

  /// `Keine `
  String get accountDataCardNoGuild {
    return Intl.message(
      'Keine ',
      name: 'accountDataCardNoGuild',
      desc: '',
      args: [],
    );
  }

  /// `Gilde`
  String get accountDataCardGuild {
    return Intl.message(
      'Gilde',
      name: 'accountDataCardGuild',
      desc: '',
      args: [],
    );
  }

  /// `Fraktion: `
  String get accountDataCardFactionLabel {
    return Intl.message(
      'Fraktion: ',
      name: 'accountDataCardFactionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Zone: `
  String get accountDataCardZoneLabel {
    return Intl.message(
      'Zone: ',
      name: 'accountDataCardZoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Klasse: `
  String get accountDataCardClassLabel {
    return Intl.message(
      'Klasse: ',
      name: 'accountDataCardClassLabel',
      desc: '',
      args: [],
    );
  }

  /// `Gold: `
  String get accountDataCardGoldLabel {
    return Intl.message(
      'Gold: ',
      name: 'accountDataCardGoldLabel',
      desc: '',
      args: [],
    );
  }

  /// `Zuletzt Online: `
  String get accountDataCardLastLogoutLabel {
    return Intl.message(
      'Zuletzt Online: ',
      name: 'accountDataCardLastLogoutLabel',
      desc: '',
      args: [],
    );
  }

  /// `ID's`
  String get accountDataCardInstancesTitle {
    return Intl.message(
      'ID\'s',
      name: 'accountDataCardInstancesTitle',
      desc: '',
      args: [],
    );
  }

  /// `NULL`
  String get accountDataCardNullValue {
    return Intl.message(
      'NULL',
      name: 'accountDataCardNullValue',
      desc: '',
      args: [],
    );
  }

  /// `Keine Daten vorhanden!`
  String get accountDataCardNoData {
    return Intl.message(
      'Keine Daten vorhanden!',
      name: 'accountDataCardNoData',
      desc: '',
      args: [],
    );
  }

  /// `Zurück`
  String get accountAddPageBackButton {
    return Intl.message(
      'Zurück',
      name: 'accountAddPageBackButton',
      desc: '',
      args: [],
    );
  }

  /// `Speichern`
  String get accountAddPageSaveButton {
    return Intl.message(
      'Speichern',
      name: 'accountAddPageSaveButton',
      desc: '',
      args: [],
    );
  }

  /// `Listen Name`
  String get accountAddPageListNameHint {
    return Intl.message(
      'Listen Name',
      name: 'accountAddPageListNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Account Name`
  String get accountAddPageAccountNameHint {
    return Intl.message(
      'Account Name',
      name: 'accountAddPageAccountNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Account Passwort`
  String get accountAddPagePasswordHint {
    return Intl.message(
      'Account Passwort',
      name: 'accountAddPagePasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `reset`
  String get accountScreenResetButton {
    return Intl.message(
      'reset',
      name: 'accountScreenResetButton',
      desc: '',
      args: [],
    );
  }

  /// `Update erforderlich: {message}`
  String splashScreenUpdateRequired(Object message) {
    return Intl.message(
      'Update erforderlich: $message',
      name: 'splashScreenUpdateRequired',
      desc: '',
      args: [message],
    );
  }

  /// `Wartung`
  String get splashScreenMaintenance {
    return Intl.message(
      'Wartung',
      name: 'splashScreenMaintenance',
      desc: '',
      args: [],
    );
  }

  /// `Eula nicht akzeptiert`
  String get splashScreenEulaNotAccepted {
    return Intl.message(
      'Eula nicht akzeptiert',
      name: 'splashScreenEulaNotAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Erste Initialisierung`
  String get splashScreenInitializedFirstStart {
    return Intl.message(
      'Erste Initialisierung',
      name: 'splashScreenInitializedFirstStart',
      desc: '',
      args: [],
    );
  }

  /// `initialisiert`
  String get splashScreenInitialized {
    return Intl.message(
      'initialisiert',
      name: 'splashScreenInitialized',
      desc: '',
      args: [],
    );
  }

  /// `blockierender Fehler: {message}`
  String splashScreenBlockingError(Object message) {
    return Intl.message(
      'blockierender Fehler: $message',
      name: 'splashScreenBlockingError',
      desc: '',
      args: [message],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Localize> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Localize> load(Locale locale) => Localize.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
