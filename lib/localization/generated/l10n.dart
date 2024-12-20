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
    assert(_current != null,
        'No instance of Localize was loaded. Try to initialize the Localize delegate before accessing Localize.current.');
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
    assert(instance != null,
        'No instance of Localize present in the widget tree. Did you add Localize.delegate in localizationsDelegates?');
    return instance!;
  }

  static Localize? maybeOf(BuildContext context) {
    return Localizations.of<Localize>(context, Localize);
  }

  /// `WOW-Launcher`
  String get appTitle {
    return Intl.message(
      'WOW-Launcher',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ja`
  String get yes {
    return Intl.message(
      'Ja',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Nein`
  String get no {
    return Intl.message(
      'Nein',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Speichern`
  String get save {
    return Intl.message(
      'Speichern',
      name: 'save',
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
    return Intl.message(
      'M E N Ü',
      name: 'menuTitle',
      desc: '',
      args: [],
    );
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
  String get addAccountScreenTitle {
    return Intl.message(
      'Account hinzufügen',
      name: 'addAccountScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `N e u e r   A c c o u n t`
  String get addAccountScreenNewAccount {
    return Intl.message(
      'N e u e r   A c c o u n t',
      name: 'addAccountScreenNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Listen Name`
  String get addAccountScreenListNameLabel {
    return Intl.message(
      'Listen Name',
      name: 'addAccountScreenListNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Account Name`
  String get addAccountScreenAccountNameLabel {
    return Intl.message(
      'Account Name',
      name: 'addAccountScreenAccountNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Account Passwort`
  String get addAccountScreenPasswordLabel {
    return Intl.message(
      'Account Passwort',
      name: 'addAccountScreenPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Realm/Logonserver`
  String get addAccountScreenRealmLabel {
    return Intl.message(
      'Realm/Logonserver',
      name: 'addAccountScreenRealmLabel',
      desc: '',
      args: [],
    );
  }

  /// `WoW-Speicherort`
  String get settingsScreenWowPath {
    return Intl.message(
      'WoW-Speicherort',
      name: 'settingsScreenWowPath',
      desc: '',
      args: [],
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
