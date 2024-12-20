part of 'character_data_cubit.dart';

@freezed
class CharacterDataState with _$CharacterDataState {
  const factory CharacterDataState.initial() = _initial;
  const factory CharacterDataState.initialized(
      {required List<dynamic>? characterList}) = _initialized;
  const factory CharacterDataState.failed({required String errorMsg}) = _failed;
}
