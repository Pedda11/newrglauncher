part of 'account_screen_cubit.dart';

@freezed
class AccountScreenState with _$AccountScreenState {
  const factory AccountScreenState.initial() = _initial;

  const factory AccountScreenState.initialized() = _initialized;

  const factory AccountScreenState.accountAdded() = _accountAdded;

  const factory AccountScreenState.deletingAccount() = _deletingAccount;

  const factory AccountScreenState.goToAddAccountPage() = _goToAddAccountPage;

  const factory AccountScreenState.failed({required String errorMsg}) = _failed;
}
