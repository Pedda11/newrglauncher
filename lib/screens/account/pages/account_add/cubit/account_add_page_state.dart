part of 'account_add_page_cubit.dart';

@Freezed(equal: false)
class AccountAddPageState with _$AccountAddPageState {
  const factory AccountAddPageState.initial() = _initial;

  const factory AccountAddPageState.initialized() = _initialized;

  const factory AccountAddPageState.changeVisibility(
      {required bool isVisible}) = _changeVisibility;

  const factory AccountAddPageState.addingNewAccount() = _addingNewAccount;

  const factory AccountAddPageState.accountAdded() = _accountAdded;

  const factory AccountAddPageState.failed({required String errorMsg}) =
      _failed;
}
