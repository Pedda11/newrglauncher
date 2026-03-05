// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_data_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CharacterDataState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CharacterDataState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CharacterDataState()';
  }
}

/// @nodoc
class $CharacterDataStateCopyWith<$Res> {
  $CharacterDataStateCopyWith(
      CharacterDataState _, $Res Function(CharacterDataState) __);
}

/// Adds pattern-matching-related methods to [CharacterDataState].
extension CharacterDataStatePatterns on CharacterDataState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_initial value)? initial,
    TResult Function(_initialized value)? initialized,
    TResult Function(_accountLoaded value)? accountLoaded,
    TResult Function(_failed value)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _initialized() when initialized != null:
        return initialized(_that);
      case _accountLoaded() when accountLoaded != null:
        return accountLoaded(_that);
      case _failed() when failed != null:
        return failed(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_initial value) initial,
    required TResult Function(_initialized value) initialized,
    required TResult Function(_accountLoaded value) accountLoaded,
    required TResult Function(_failed value) failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial(_that);
      case _initialized():
        return initialized(_that);
      case _accountLoaded():
        return accountLoaded(_that);
      case _failed():
        return failed(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_initial value)? initial,
    TResult? Function(_initialized value)? initialized,
    TResult? Function(_accountLoaded value)? accountLoaded,
    TResult? Function(_failed value)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _initialized() when initialized != null:
        return initialized(_that);
      case _accountLoaded() when accountLoaded != null:
        return accountLoaded(_that);
      case _failed() when failed != null:
        return failed(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? initialized,
    TResult Function(List<dynamic>? characterList)? accountLoaded,
    TResult Function(String errorMsg)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _initialized() when initialized != null:
        return initialized();
      case _accountLoaded() when accountLoaded != null:
        return accountLoaded(_that.characterList);
      case _failed() when failed != null:
        return failed(_that.errorMsg);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() initialized,
    required TResult Function(List<dynamic>? characterList) accountLoaded,
    required TResult Function(String errorMsg) failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial();
      case _initialized():
        return initialized();
      case _accountLoaded():
        return accountLoaded(_that.characterList);
      case _failed():
        return failed(_that.errorMsg);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? initialized,
    TResult? Function(List<dynamic>? characterList)? accountLoaded,
    TResult? Function(String errorMsg)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _initialized() when initialized != null:
        return initialized();
      case _accountLoaded() when accountLoaded != null:
        return accountLoaded(_that.characterList);
      case _failed() when failed != null:
        return failed(_that.errorMsg);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _initial implements CharacterDataState {
  const _initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CharacterDataState.initial()';
  }
}

/// @nodoc

class _initialized implements CharacterDataState {
  const _initialized();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _initialized);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CharacterDataState.initialized()';
  }
}

/// @nodoc

class _accountLoaded implements CharacterDataState {
  const _accountLoaded({required final List<dynamic>? characterList})
      : _characterList = characterList;

  final List<dynamic>? _characterList;
  List<dynamic>? get characterList {
    final value = _characterList;
    if (value == null) return null;
    if (_characterList is EqualUnmodifiableListView) return _characterList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of CharacterDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$accountLoadedCopyWith<_accountLoaded> get copyWith =>
      __$accountLoadedCopyWithImpl<_accountLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _accountLoaded &&
            const DeepCollectionEquality()
                .equals(other._characterList, _characterList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_characterList));

  @override
  String toString() {
    return 'CharacterDataState.accountLoaded(characterList: $characterList)';
  }
}

/// @nodoc
abstract mixin class _$accountLoadedCopyWith<$Res>
    implements $CharacterDataStateCopyWith<$Res> {
  factory _$accountLoadedCopyWith(
          _accountLoaded value, $Res Function(_accountLoaded) _then) =
      __$accountLoadedCopyWithImpl;
  @useResult
  $Res call({List<dynamic>? characterList});
}

/// @nodoc
class __$accountLoadedCopyWithImpl<$Res>
    implements _$accountLoadedCopyWith<$Res> {
  __$accountLoadedCopyWithImpl(this._self, this._then);

  final _accountLoaded _self;
  final $Res Function(_accountLoaded) _then;

  /// Create a copy of CharacterDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? characterList = freezed,
  }) {
    return _then(_accountLoaded(
      characterList: freezed == characterList
          ? _self._characterList
          : characterList // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
    ));
  }
}

/// @nodoc

class _failed implements CharacterDataState {
  const _failed({required this.errorMsg});

  final String errorMsg;

  /// Create a copy of CharacterDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$failedCopyWith<_failed> get copyWith =>
      __$failedCopyWithImpl<_failed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _failed &&
            (identical(other.errorMsg, errorMsg) ||
                other.errorMsg == errorMsg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMsg);

  @override
  String toString() {
    return 'CharacterDataState.failed(errorMsg: $errorMsg)';
  }
}

/// @nodoc
abstract mixin class _$failedCopyWith<$Res>
    implements $CharacterDataStateCopyWith<$Res> {
  factory _$failedCopyWith(_failed value, $Res Function(_failed) _then) =
      __$failedCopyWithImpl;
  @useResult
  $Res call({String errorMsg});
}

/// @nodoc
class __$failedCopyWithImpl<$Res> implements _$failedCopyWith<$Res> {
  __$failedCopyWithImpl(this._self, this._then);

  final _failed _self;
  final $Res Function(_failed) _then;

  /// Create a copy of CharacterDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? errorMsg = null,
  }) {
    return _then(_failed(
      errorMsg: null == errorMsg
          ? _self.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
