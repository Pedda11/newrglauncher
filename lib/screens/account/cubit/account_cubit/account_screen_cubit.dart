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
import '../../../../repository/main_repository.dart';
import '../../../../repository/preferences_repository.dart';
import '../../../../repository/settings_repository.dart';

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
    await loadAccounts();
  }

  Future<void> loadAccounts() async {
    try {
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
    } catch (e) {
      emit(AccountScreenState.failed(errorMsg: e.toString()));
    }
  }

  void deleteSingleAccount(Account acc) async {
    try {
      emit(const AccountScreenState.deletingAccount());
      mainRepository.accountList.remove(acc);

      List<String> accStringList = [];

      for (Account a in mainRepository.accountList) {
        String accountString = jsonEncode(a.toJson());
        accStringList.add(accountString);
      }

      await preferencesRepository.setAccounts(accStringList);
    } catch (e) {
      emit(AccountScreenState.failed(errorMsg: e.toString()));
    }
    await loadAccounts();
  }

  void goToAccountAddPage() {
    emit(const AccountScreenState.goToAddAccountPage());
  }

  void _sendKey(int keyCode, {bool shift = false}) {
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
      emit(const AccountScreenState.failed(
          errorMsg: 'Ungültige Wartezeit für den Spielstart.'));
      return;
    }
    try {
      final process = await Process.start(
          '${settingsRepository.wowRootFolderPath}${settingsRepository.wowExecutableName}',
          []);

      await Future.delayed(
          Duration(seconds: settingsRepository.secondsToWaitForGameToStart!));

      await sendKeys(acc.accountName, acc.accountPassword);
    } catch (e) {
      emit(AccountScreenState.failed(errorMsg: e.toString()));
    }
  }
}
