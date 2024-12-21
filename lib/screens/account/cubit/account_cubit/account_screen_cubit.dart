import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/account.dart';
import '../../../../repository/main_repository.dart';
import '../../../../repository/preferences_repository.dart';

part 'account_screen_state.dart';

part 'account_screen_cubit.freezed.dart';

class AccountScreenCubit extends Cubit<AccountScreenState> {
  final MainRepository mainRepository;
  final PreferencesRepository preferencesRepository;

  AccountScreenCubit(
      {required this.mainRepository, required this.preferencesRepository})
      : super(const AccountScreenState.initial());

  Future<void> initialize() async {
    await loadAccounts();
  }

  Future<void> loadAccounts() async {
    List<String>? list = await preferencesRepository.getAccounts();
    mainRepository.accountList = [];
    list ??= [];
    if (list.isNotEmpty) {
      for (String s in list) {
        Account acc = Account.fromJson(jsonDecode(s));
        mainRepository.accountList.add(acc);
      }
      emit(AccountScreenState.initialized());
    } else {
      emit(const AccountScreenState.goToAddAccountPage());
    }
  }

  void deleteSingleAccount(Account acc) async {
    emit(AccountScreenState.deletingAccount());
    mainRepository.accountList.remove(acc);

    List<String> accStringList = [];

    for (Account a in mainRepository.accountList) {
      String accountString = jsonEncode(a.toJson());
      accStringList.add(accountString);
    }

    await preferencesRepository.setAccounts(accStringList);
    await loadAccounts();
  }

  void goToAccountAddPage() {
    emit(AccountScreenState.goToAddAccountPage());
  }
}
