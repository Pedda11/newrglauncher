// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_add_page_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountAddPageState {
  @override
  String toString() {
    return 'AccountAddPageState()';
  }
}

/// @nodoc
class $AccountAddPageStateCopyWith<$Res> {
  $AccountAddPageStateCopyWith(
      AccountAddPageState _, $Res Function(AccountAddPageState) __);
}

/// Adds pattern-matching-related methods to [AccountAddPageState].
extension AccountAddPageStatePatterns on AccountAddPageState {
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
    TResult Function(_changeVisibility value)? changeVisibility,
    TResult Function(_addingNewAccount value)? addingNewAccount,
    TResult Function(_accountAdded value)? accountAdded,
    TResult Function(_failed value)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _initialized() when initialized != null:
        return initialized(_that);
      case _changeVisibility() when changeVisibility != null:
        return changeVisibility(_that);
      case _addingNewAccount() when addingNewAccount != null:
        return addingNewAccount(_that);
      case _accountAdded() when accountAdded != null:
        return accountAdded(_that);
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
    required TResult Function(_changeVisibility value) changeVisibility,
    required TResult Function(_addingNewAccount value) addingNewAccount,
    required TResult Function(_accountAdded value) accountAdded,
    required TResult Function(_failed value) failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial(_that);
      case _initialized():
        return initialized(_that);
      case _changeVisibility():
        return changeVisibility(_that);
      case _addingNewAccount():
        return addingNewAccount(_that);
      case _accountAdded():
        return accountAdded(_that);
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
    TResult? Function(_changeVisibility value)? changeVisibility,
    TResult? Function(_addingNewAccount value)? addingNewAccount,
    TResult? Function(_accountAdded value)? accountAdded,
    TResult? Function(_failed value)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _initialized() when initialized != null:
        return initialized(_that);
      case _changeVisibility() when changeVisibility != null:
        return changeVisibility(_that);
      case _addingNewAccount() when addingNewAccount != null:
        return addingNewAccount(_that);
      case _accountAdded() when accountAdded != null:
        return accountAdded(_that);
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
    TResult Function(bool isVisible)? changeVisibility,
    TResult Function()? addingNewAccount,
    TResult Function()? accountAdded,
    TResult Function(String errorMsg)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _initialized() when initialized != null:
        return initialized();
      case _changeVisibility() when changeVisibility != null:
        return changeVisibility(_that.isVisible);
      case _addingNewAccount() when addingNewAccount != null:
        return addingNewAccount();
      case _accountAdded() when accountAdded != null:
        return accountAdded();
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
    required TResult Function(bool isVisible) changeVisibility,
    required TResult Function() addingNewAccount,
    required TResult Function() accountAdded,
    required TResult Function(String errorMsg) failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial();
      case _initialized():
        return initialized();
      case _changeVisibility():
        return changeVisibility(_that.isVisible);
      case _addingNewAccount():
        return addingNewAccount();
      case _accountAdded():
        return accountAdded();
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
    TResult? Function(bool isVisible)? changeVisibility,
    TResult? Function()? addingNewAccount,
    TResult? Function()? accountAdded,
    TResult? Function(String errorMsg)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _initialized() when initialized != null:
        return initialized();
      case _changeVisibility() when changeVisibility != null:
        return changeVisibility(_that.isVisible);
      case _addingNewAccount() when addingNewAccount != null:
        return addingNewAccount();
      case _accountAdded() when accountAdded != null:
        return accountAdded();
      case _failed() when failed != null:
        return failed(_that.errorMsg);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _initial implements AccountAddPageState {
  const _initial();

  @override
  String toString() {
    return 'AccountAddPageState.initial()';
  }
}

/// @nodoc

class _initialized implements AccountAddPageState {
  const _initialized();

  @override
  String toString() {
    return 'AccountAddPageState.initialized()';
  }
}

/// @nodoc

class _changeVisibility implements AccountAddPageState {
  const _changeVisibility({required this.isVisible});

  final bool isVisible;

  /// Create a copy of AccountAddPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$changeVisibilityCopyWith<_changeVisibility> get copyWith =>
      __$changeVisibilityCopyWithImpl<_changeVisibility>(this, _$identity);

  @override
  String toString() {
    return 'AccountAddPageState.changeVisibility(isVisible: $isVisible)';
  }
}

/// @nodoc
abstract mixin class _$changeVisibilityCopyWith<$Res>
    implements $AccountAddPageStateCopyWith<$Res> {
  factory _$changeVisibilityCopyWith(
          _changeVisibility value, $Res Function(_changeVisibility) _then) =
      __$changeVisibilityCopyWithImpl;
  @useResult
  $Res call({bool isVisible});
}

/// @nodoc
class __$changeVisibilityCopyWithImpl<$Res>
    implements _$changeVisibilityCopyWith<$Res> {
  __$changeVisibilityCopyWithImpl(this._self, this._then);

  final _changeVisibility _self;
  final $Res Function(_changeVisibility) _then;

  /// Create a copy of AccountAddPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isVisible = null,
  }) {
    return _then(_changeVisibility(
      isVisible: null == isVisible
          ? _self.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _addingNewAccount implements AccountAddPageState {
  const _addingNewAccount();

  @override
  String toString() {
    return 'AccountAddPageState.addingNewAccount()';
  }
}

/// @nodoc

class _accountAdded implements AccountAddPageState {
  const _accountAdded();

  @override
  String toString() {
    return 'AccountAddPageState.accountAdded()';
  }
}

/// @nodoc

class _failed implements AccountAddPageState {
  const _failed({required this.errorMsg});

  final String errorMsg;

  /// Create a copy of AccountAddPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$failedCopyWith<_failed> get copyWith =>
      __$failedCopyWithImpl<_failed>(this, _$identity);

  @override
  String toString() {
    return 'AccountAddPageState.failed(errorMsg: $errorMsg)';
  }
}

/// @nodoc
abstract mixin class _$failedCopyWith<$Res>
    implements $AccountAddPageStateCopyWith<$Res> {
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

  /// Create a copy of AccountAddPageState
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
