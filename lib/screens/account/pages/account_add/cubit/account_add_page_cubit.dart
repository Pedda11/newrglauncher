import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../data/account.dart';
import '../../../../../repository/main_repository.dart';
import '../../../../../repository/preferences_repository.dart';

part 'account_add_page_state.dart';

part 'account_add_page_cubit.freezed.dart';

class AccountAddPageCubit extends Cubit<AccountAddPageState> {
  final MainRepository mainRepository;
  final PreferencesRepository preferencesRepository;

  AccountAddPageCubit({
    required this.mainRepository,
    required this.preferencesRepository,
  }) : super(const AccountAddPageState.initial());

  void initialize() {
    emit(const AccountAddPageState.initialized());
  }

  void changeVisibility(bool isVisible) {
    emit(AccountAddPageState.changeVisibility(isVisible: isVisible));
  }

  void addAccount(Account account) {
    try {
      List<int> ids = [];

      for (Account a in mainRepository.accountList) {
        ids.add(a.accId);
      }

      if (ids.isNotEmpty) {
        ids.sort();
        int i = ids[ids.length - 1];
        account.accId = i + 1;
      }
      mainRepository.accountList.add(account);

      List<String> accStringList = [];

      for (Account a in mainRepository.accountList) {
        String accountString = jsonEncode(a.toJson());
        accStringList.add(accountString);
      }

      preferencesRepository.setAccounts(accStringList);
    } catch (e) {
      emit(AccountAddPageState.failed(errorMsg: e.toString()));
    }
    emit(const AccountAddPageState.accountAdded());
  }
}
