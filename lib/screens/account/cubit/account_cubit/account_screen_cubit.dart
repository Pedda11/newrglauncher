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
import '../../../../data/character.dart';
import '../../../../helper/error_report_builder.dart';
import '../../../../repository/credential_repository.dart';
import '../../../../repository/error_report_repository.dart';
import '../../../../repository/error_repository.dart';
import '../../../../repository/main_repository.dart';
import '../../../../repository/preferences_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../../services/account_data_refresh_service.dart';
import '../../../../services/totp/totp_service.dart';
import '../../../../widgets/log.dart';
import 'package:path/path.dart' as p;

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

  final _totpService = TotpService();

  bool inProgress = false;

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

  Future<void> editAccount(Account acc) async {
    mainRepository.account = acc;
    emit(const AccountScreenState.editAccount());
  }

  void deleteSingleAccount(Account acc) async {
    try {
      await Log.i('Deleting account with id: ${acc.accId}');
      emit(const AccountScreenState.deletingAccount());

      mainRepository.accountList.removeWhere((a) => a.uniqueId == acc.uniqueId);

      List<String> accStringList = [];

      await Log.i('Updating accounts in PreferencesRepository after deletion');
      for (Account a in mainRepository.accountList) {
        String accountString = jsonEncode(a.toJson());
        accStringList.add(accountString);
      }

      try {
        await CredentialRepository().deletePassword('#${acc.uniqueId}#');
      } catch (e, st) {
        await Log.i(
            'Error occurred while deleting password for account with id: ${acc.accId}, error: $e');
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
    emit(const AccountScreenState.initialized());
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
    if (inProgress) return;

    inProgress = true;

    await Log.i('Starting game for account: ${acc.accountName}');
    try {
      final wowProcess = await startWowProcess(
        wowRootPath: settingsRepository.wowRootFolderPath!,
        wowExecutableName: settingsRepository.wowExecutableName!,
      );

      await Log.i('WoW started with pid: ${wowProcess.pid}');

      await Log.i(
          'Game process started, waiting for ${settingsRepository.secondsToWaitForGameToStart} seconds before sending keys');
      await Future.delayed(
          Duration(seconds: settingsRepository.secondsToWaitForGameToStart!));

      await _bringWowToForeground();

      final accPasswd = await CredentialRepository().readPassword(acc.uniqueId);

      if (accPasswd == null) {
        await Log.i('Password not found in Credential Manager.');
        emit(const AccountScreenState.failed(
            errorMsg: 'Passwort konnte nicht gefunden werden.'));
        inProgress = false;
        return;
      }

      await Log.i('Sending keys for account: ${acc.accId}');

      await sendKeys(acc.accountName, accPasswd);
      if (acc.isTotpEnabled) {
        await Log.i('2FA enabled for account: ${acc.accountName}');

        /// wait for 2FA popup to appear
        await Future.delayed(const Duration(seconds: 2));

        await _bringWowToForeground();

        final secret =
            await CredentialRepository().readTotpSecret(acc.uniqueId);

        if (secret == null) {
          await Log.i('TOTP secret not found for account.');
          emit(const AccountScreenState.failed(
              errorMsg: '2FA aktiviert, aber kein Secret gespeichert.'));
          inProgress = false;
          return;
        }

        final code = _totpService.generateCode(secret: secret);

        await Log.i('Generated TOTP code, sending input');

        await sendText(code, pressEnter: true);
        inProgress = false;
      }
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
      inProgress = false;
      emit(AccountScreenState.failed(errorMsg: e.toString()));
    }
    try {
      final refreshService = AccountDataRefreshService(
        mainRepository: mainRepository,
        settingsRepository: settingsRepository,
      );

      await refreshService.refreshAccount(acc);
    } on PathNotFoundException catch (e) {
      await Log.i('Error while reading character data: ${e.toString()}');
      return;
    } catch (e, st) {
      await Log.i('Error while reading character data: ${e.toString()}');
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

  Future<Process> startWowProcess({
    required String wowRootPath,
    required String wowExecutableName,
  }) async {
    if (wowRootPath.isEmpty) {
      throw StateError('WoW root path is missing.');
    }

    if (wowExecutableName.isEmpty) {
      throw StateError('WoW executable name is missing.');
    }

    final exePath = p.join(wowRootPath, wowExecutableName);

    final exeFile = File(exePath);
    if (!await exeFile.exists()) {
      throw StateError('WoW executable not found: $exePath');
    }

    await Log.i('Starting WoW directly');
    await Log.i('WoW root: $wowRootPath');
    await Log.i('WoW exe: $exePath');
    await Log.i('WoW start mode: direct Process.start');

    final process = await Process.start(
      exePath,
      const [],
      workingDirectory: wowRootPath,
      runInShell: true,
    );

    await Log.i('WoW process pid: ${process.pid}');

    return process;
  }

  Future<void> sendText(String text, {bool pressEnter = false}) async {
    for (var char in text.split('')) {
      final vkCode = _charToVirtualKeyCode(char);
      final shift = _isShiftRequired(char);
      _sendKey(vkCode, shift: shift);
    }

    if (pressEnter) {
      _sendKey(VIRTUAL_KEY.VK_RETURN);
    }
  }

  Future<void> _logVisibleWindows() async {
    final results = <String>[];

    _windowDumpResults = results;

    try {
      final enumCallback =
          Pointer.fromFunction<WNDENUMPROC>(enumWindowsDumpProc, 1);

      EnumWindows(enumCallback, 0);

      await Log.i('=== Visible windows dump start ===');
      for (final line in results) {
        await Log.i(line);
      }
      await Log.i('=== Visible windows dump end ===');
    } finally {
      _windowDumpResults = null;
    }
  }

  Future<void> _bringWowToForeground() async {
    int hWnd = 0;

    for (int i = 0; i < 20; i++) {
      hWnd = _findWindowByTitle('World of Warcraft');

      if (hWnd != 0) {
        break;
      }

      await Future.delayed(const Duration(milliseconds: 500));
    }

    await Log.i('WoW window handle by title: $hWnd');

    if (hWnd == 0) {
      emit(const AccountScreenState.failed(
        errorMsg: 'WoW Fenster konnte nicht gefunden werden.',
      ));
      return;
    }

    ShowWindow(hWnd, SHOW_WINDOW_CMD.SW_RESTORE);
    await Future.delayed(const Duration(milliseconds: 150));
    SetForegroundWindow(hWnd);
    await Future.delayed(const Duration(milliseconds: 150));
  }

  int _findWindowByTitle(String title) {
    final resultPointer = calloc<IntPtr>();

    try {
      final enumCallback =
          Pointer.fromFunction<WNDENUMPROC>(enumWindowsByTitleProc, 1);

      _windowSearchTitle = title;
      _windowSearchResultPointer = resultPointer;

      EnumWindows(enumCallback, 0);

      return resultPointer.value;
    } finally {
      _windowSearchTitle = null;
      _windowSearchResultPointer = null;
      calloc.free(resultPointer);
    }
  }
}

//top level variables and functions---------------------------------------
int enumWindowsProc(int hWnd, int lParam) {
  final targetPid = _windowSearchTargetPid;
  final resultPointer = _windowSearchResultPointer;

  if (targetPid == null || resultPointer == null) {
    return 1;
  }

  if (IsWindowVisible(hWnd) == 0) {
    return 1;
  }

  final pidPointer = calloc<Uint32>();

  try {
    GetWindowThreadProcessId(hWnd, pidPointer);

    if (pidPointer.value == targetPid) {
      resultPointer.value = hWnd;
      return 0;
    }

    return 1;
  } finally {
    calloc.free(pidPointer);
  }
}

String? _windowSearchTitle;
List<String>? _windowDumpResults;
int? _windowSearchTargetPid;
Pointer<IntPtr>? _windowSearchResultPointer;

int enumWindowsByTitleProc(int hWnd, int lParam) {
  final searchTitle = _windowSearchTitle;
  final resultPointer = _windowSearchResultPointer;

  if (searchTitle == null || resultPointer == null) {
    return 1;
  }

  if (IsWindowVisible(hWnd) == 0) {
    return 1;
  }

  final titleBuffer = wsalloc(512);

  try {
    final titleLength = GetWindowText(hWnd, titleBuffer, 512);
    final title = titleLength > 0 ? titleBuffer.toDartString() : '';

    if (title.trim() == searchTitle) {
      resultPointer.value = hWnd;
      return 0;
    }

    return 1;
  } finally {
    calloc.free(titleBuffer);
  }
}

int _findWindowByPid(int targetPid) {
  final resultPointer = calloc<IntPtr>();

  try {
    final enumCallback = Pointer.fromFunction<WNDENUMPROC>(enumWindowsProc, 1);

    _windowSearchTargetPid = targetPid;
    _windowSearchResultPointer = resultPointer;

    EnumWindows(enumCallback, 0);

    return resultPointer.value;
  } finally {
    _windowSearchTargetPid = null;
    _windowSearchResultPointer = null;
    calloc.free(resultPointer);
  }
}

int enumWindowsDumpProc(int hWnd, int lParam) {
  final results = _windowDumpResults;
  if (results == null) {
    return 1;
  }

  if (IsWindowVisible(hWnd) == 0) {
    return 1;
  }

  final pidPointer = calloc<Uint32>();
  final titleBuffer = wsalloc(512);

  try {
    GetWindowThreadProcessId(hWnd, pidPointer);
    final titleLength = GetWindowText(hWnd, titleBuffer, 512);
    final title = titleLength > 0 ? titleBuffer.toDartString() : '';

    if (title.trim().isNotEmpty) {
      results.add('hWnd=$hWnd | pid=${pidPointer.value} | title=$title');
    }

    return 1;
  } finally {
    calloc.free(pidPointer);
    calloc.free(titleBuffer);
  }
}
