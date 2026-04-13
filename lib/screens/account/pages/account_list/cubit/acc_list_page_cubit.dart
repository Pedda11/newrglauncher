import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twodotnulllauncher/repository/preferences_repository.dart';
import '../../../../../data/account.dart';
import '../../../../../repository/main_repository.dart';

part 'acc_list_page_state.dart';

part 'acc_list_page_cubit.freezed.dart';

class AccListPageCubit extends Cubit<AccListPageState> {
  final MainRepository mainRepository;
  final PreferencesRepository preferencesRepository;

  AccListPageCubit(
      {required this.mainRepository, required this.preferencesRepository})
      : super(const AccListPageState.initial());

  Future<void> reorderAccounts(int oldIndex, int newIndex) async {
    emit(const AccListPageState.initial());

    final accounts = [...mainRepository.accountList]
      ..sort((a, b) => a.accId.compareTo(b.accId));

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final movedAccount = accounts.removeAt(oldIndex);
    accounts.insert(newIndex, movedAccount);

    for (var i = 0; i < accounts.length; i++) {
      accounts[i].accId = i;
    }

    mainRepository.accountList = accounts;

    final accStringList = <String>[];

    for (final a in mainRepository.accountList) {
      final accountString = jsonEncode(a.toJson());
      accStringList.add(accountString);
    }

    await preferencesRepository.setAccounts(accStringList);

    emit(AccListPageState.reordered(accounts: accounts));
  }

  Future<void> loadAccounts() async {
    emit(const AccListPageState.initial());

    final accounts = [...mainRepository.accountList]
      ..sort((a, b) => a.accId.compareTo(b.accId));

    emit(AccListPageState.reordered(accounts: accounts));
  }
}
