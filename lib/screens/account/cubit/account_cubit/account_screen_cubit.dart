import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twodotnulllauncher/repository/account_repository.dart';
import '../../../../data/account.dart';
import '../../../../data/altoholic.dart';
import '../../../../repository/main_repository.dart';

part 'account_screen_state.dart';

part 'account_screen_cubit.freezed.dart';

class AccountScreenCubit extends Cubit<AccountScreenState> {
  final MainRepository mainRepository;
  final PreferencesRepository preferencesRepository;

  AccountScreenCubit(
      {required this.mainRepository, required this.preferencesRepository})
      : super(const AccountScreenState.initial());

  saveAccounts(Account? acc, MainRepository accRepo) async {
    List<String> accStringList = [];
    List<int> ids = [];

    accRepo.accountList ??= [];
    for (Account a in accRepo.accountList!) {
      ids.add(a.accId);
    }

    if (acc != null) {
      if (ids.isNotEmpty) {
        ids.sort();
        int i = ids[ids.length - 1];
        acc.accId = i + 1;
      }
      accRepo.accountList!.add(acc);
    }

    for (Account a in accRepo.accountList!) {
      String accountString = jsonEncode(a.toJson());
      accStringList.add(accountString);
    }

    preferencesRepository.setAccounts(accStringList);

    emit(const AccountScreenState.noAccounts());
  }

  Future<void> loadAccounts(MainRepository mainRepository) async {
    List<String>? list = await preferencesRepository.getAccounts();
    mainRepository.accountList = [];
    list ??= [];
    if (list.isNotEmpty) {
      for (String s in list) {
        Account acc = Account.fromJson(jsonDecode(s));
        mainRepository.accountList!.add(acc);
      }
      emit(AccountScreenState.initialized(
          accountList: mainRepository.accountList!));
    } else {
      emit(const AccountScreenState.noAccounts());
    }
  }

/*
  realmChanged(String realm) {
    //currentRealm = realm;
    emit(AccountSuccess());
  }*/

  deleteSingleAccount(MainRepository accRepo, Account acc) {
    accRepo.accountList!.remove(acc);

    saveAccounts(null, accRepo);

    return accRepo;
  }

  changePwVisibility() {
    /*if (showPw) {
      showPw = !showPw;
      emit(AccountSuccess());
    } else {
      showPw = !showPw;
      emit(AccountSuccess());
    }*/
  }

  List<ProcessInfo> processInfoList = [];
  late Process _process;
  late Timer _timer;

  startProcessMonitoring(String path) async {
    _process = await Process.start(path, []);

    Timer(const Duration(seconds: 20), () {
      /*var hwnd = GetFocus();

      if (kDebugMode) {
        print(hwnd);
      }*/
    });

    /*
    // Startet einen Timer, der jede Sekunde Prozessinformationen abruft
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final processInfo = await _getProcessInfo();
      processInfoList.add(processInfo);
    });*/
  }

  Future<void> stopProcessMonitoring() async {
    _timer.cancel();
    _process.kill();
  }
}

class ProcessInfo {
  final int pid;
  final Stream<List<int>> pOut;

  ProcessInfo(this.pid, this.pOut);
}
