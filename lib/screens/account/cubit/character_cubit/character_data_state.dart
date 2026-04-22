part of 'character_data_cubit.dart';

@freezed
class CharacterDataState with _$CharacterDataState {
  const factory CharacterDataState.initial() = _initial;

  const factory CharacterDataState.initialized() = _initialized;

  const factory CharacterDataState.accountLoaded({
    required Account account,
    required List<Character> characterList,
  }) = _accountLoaded;

  const factory CharacterDataState.noData() = _noData;

  const factory CharacterDataState.failed({required String errorMsg}) = _failed;
}
