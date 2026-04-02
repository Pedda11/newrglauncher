part of 'acc_list_page_cubit.dart';

@freezed
class AccListPageState with _$AccListPageState {
  const factory AccListPageState.initial() = _initial;

  const factory AccListPageState.reordered({required List<Account> accounts}) =
      _reordered;
}
