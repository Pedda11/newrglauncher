part of 'account_screen_cubit.dart';

@freezed
class AccountScreenState with _$AccountScreenState {
  const factory AccountScreenState.initial() = _initial;
  const factory AccountScreenState.initialized(
      {required List<Account> accountList}) = _initialized;
  const factory AccountScreenState.noAccounts() = _noAccounts;
  const factory AccountScreenState.failed() = _failed;
}
