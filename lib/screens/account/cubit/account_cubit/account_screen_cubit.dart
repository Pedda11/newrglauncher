import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/account.dart';
import '../../../../helper/error_report_builder.dart';
import '../../../../repository/credential_repository.dart';
import '../../../../repository/error_report_repository.dart';
import '../../../../repository/error_repository.dart';
import '../../../../repository/main_repository.dart';
import '../../../../repository/preferences_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../../widgets/log.dart';

part 'account_screen_state.dart';

part 'account_screen_cubit.freezed.dart';

class AccountScreenCubit extends Cubit<AccountScreenState> {
  final MainRepository mainRepository;
  final SettingsRepository settingsRepository;
  final PreferencesRepository preferencesRepository;

  AccountScreenCubit(
      {required this.mainRepository,
      required this.settingsRepository,
      required this.preferencesRepository})
      : super(const AccountScreenState.initial());

  Future<void> initialize() async {
    await Log.i('Initializing AccountScreenCubit');
    await loadAccounts();
  }

  Future<void> loadAccounts() async {
    try {
      await Log.i('Loading accounts from PreferencesRepository');
      List<String>? list = await preferencesRepository.getAccounts();
      mainRepository.accountList = [];
      list ??= [];
      if (list.isNotEmpty) {
        for (String s in list) {
          Account acc = Account.fromJson(jsonDecode(s));
          mainRepository.accountList.add(acc);
        }
        emit(const AccountScreenState.initialized());
      } else {
        emit(const AccountScreenState.goToAddAccountPage());
      }
      await Log.i(
          'Finished loading accounts, total accounts loaded: ${mainRepository.accountList.length}');
    } catch (e, st) {
      await Log.i('Error occurred while loading accounts: $e');
      final logTail = await LogReader.readLastLines(10);

      final report = await LauncherErrorReportBuilder.build(
        errorMessage: e.toString(),
        stackTrace: st.toString(),
        logTail: logTail,
      );

      await ErrorReportRepository().uploadErrorReport(
        app: 'launcher',
        report: report,
      );
      emit(AccountScreenState.failed(errorMsg: e.toString()));
    }
  }

  void deleteSingleAccount(Account acc) async {
    try {
      await Log.i('Deleting account with id: ${acc.accId}');
      emit(const AccountScreenState.deletingAccount());
      mainRepository.accountList.remove(acc);

      List<String> accStringList = [];

      await Log.i('Updating accounts in PreferencesRepository after deletion');
      for (Account a in mainRepository.accountList) {
        String accountString = jsonEncode(a.toJson());
        accStringList.add(accountString);
      }

      CredentialRepository().deletePassword(acc.accId);

      await preferencesRepository.setAccounts(accStringList);

      await Log.i(
          'Finished deleting account with id: ${acc.accId}, total accounts remaining: ${mainRepository.accountList.length}');
    } catch (e, st) {
      await Log.i(
          'Error occurred while deleting account with id: ${acc.accId}, error: $e');
      final logTail = await LogReader.readLastLines(10);

      final report = await LauncherErrorReportBuilder.build(
        errorMessage: e.toString(),
        stackTrace: st.toString(),
        logTail: logTail,
      );

      await ErrorReportRepository().uploadErrorReport(
        app: 'launcher',
        report: report,
      );
      emit(AccountScreenState.failed(errorMsg: e.toString()));
    }
    await loadAccounts();
  }

  void goToAccountAddPage() {
    emit(const AccountScreenState.goToAddAccountPage());
  }

  Future<void> _sendKey(int keyCode, {bool shift = false}) async {
    final input = calloc<INPUT>();
    input.ref.type = INPUT_TYPE.INPUT_KEYBOARD;
    input.ref.ki.wVk = keyCode;

    if (shift) {
      _sendShiftKey(true);
    }

    SendInput(1, input, sizeOf<INPUT>());

    input.ref.ki.dwFlags = KEYBD_EVENT_FLAGS.KEYEVENTF_KEYUP;
    SendInput(1, input, sizeOf<INPUT>());

    if (shift) {
      _sendShiftKey(false);
    }

    calloc.free(input);
  }

  void _sendShiftKey(bool keyDown) {
    final input = calloc<INPUT>();
    input.ref.type = INPUT_TYPE.INPUT_KEYBOARD;
    input.ref.ki.wVk = VIRTUAL_KEY.VK_SHIFT;
    if (!keyDown) {
      input.ref.ki.dwFlags = KEYBD_EVENT_FLAGS.KEYEVENTF_KEYUP;
    }
    SendInput(1, input, sizeOf<INPUT>());
    calloc.free(input);
  }

  bool _isCapsLockActive() {
    return (GetKeyState(VK_CAPITAL) & 0x0001) != 0;
  }

  int _charToVirtualKeyCode(String char) {
    final vkCode = VkKeyScan(char.codeUnitAt(0));
    return vkCode & 0xFF;
  }

  bool _isShiftRequired(String char) {
    final vkCode = VkKeyScan(char.codeUnitAt(0));
    bool shiftRequired = (vkCode & 0x100) != 0;

    if (_isCapsLockActive()) {
      if (char.toUpperCase() == char) {
        shiftRequired = !shiftRequired;
      }
    }

    return shiftRequired;
  }

  Future<void> sendKeys(String username, String password) async {
    for (var char in username.split('')) {
      final vkCode = _charToVirtualKeyCode(char);
      final shift = _isShiftRequired(char);
      _sendKey(vkCode, shift: shift);
    }

    _sendKey(VIRTUAL_KEY.VK_TAB);

    for (var char in password.split('')) {
      final vkCode = _charToVirtualKeyCode(char);
      final shift = _isShiftRequired(char);
      _sendKey(vkCode, shift: shift);
    }

    _sendKey(VIRTUAL_KEY.VK_RETURN);
  }

  Future<void> startGame(Account acc) async {
    if (settingsRepository.secondsToWaitForGameToStart == null) {
      await Log.i('Invalid wait time for game start: null');
      emit(const AccountScreenState.failed(
          errorMsg: 'Ungültige Wartezeit für den Spielstart.'));
      return;
    }
    await Log.i('Starting game for account: ${acc.accountName}');
    try {
      final process = await Process.start(
          '${settingsRepository.wowRootFolderPath}${settingsRepository.wowExecutableName}',
          []);

      await Log.i(
          'Game process started, waiting for ${settingsRepository.secondsToWaitForGameToStart} seconds before sending keys');
      await Future.delayed(
          Duration(seconds: settingsRepository.secondsToWaitForGameToStart!));

      final accPasswd = await CredentialRepository().readPassword(acc.accId);

      if (accPasswd == null) {
        await Log.i('Password not found in Credential Manager.');
        emit(const AccountScreenState.failed(
            errorMsg: 'Passwort konnte nicht gefunden werden.'));
        return;
      }

      await Log.i('Sending keys for account: ${acc.accId}');
      await sendKeys(acc.accountName, accPasswd);
    } catch (e, st) {
      await Log.i(
          'Error occurred while starting game for account: ${acc.accId}, error: $e');
      final logTail = await LogReader.readLastLines(10);

      final report = await LauncherErrorReportBuilder.build(
        errorMessage: e.toString(),
        stackTrace: st.toString(),
        logTail: logTail,
      );

      await ErrorReportRepository().uploadErrorReport(
        app: 'launcher',
        report: report,
      );
      emit(AccountScreenState.failed(errorMsg: e.toString()));
    }
  }
}
