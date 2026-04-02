// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_screen_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountScreenState implements DiagnosticableTreeMixin {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'AccountScreenState'));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountScreenState()';
  }
}

/// @nodoc
class $AccountScreenStateCopyWith<$Res> {
  $AccountScreenStateCopyWith(
      AccountScreenState _, $Res Function(AccountScreenState) __);
}

/// Adds pattern-matching-related methods to [AccountScreenState].
extension AccountScreenStatePatterns on AccountScreenState {
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
    TResult Function(_accountAdded value)? accountAdded,
    TResult Function(_deletingAccount value)? deletingAccount,
    TResult Function(_editAccount value)? editAccount,
    TResult Function(_goToAddAccountPage value)? goToAddAccountPage,
    TResult Function(_failed value)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _initialized() when initialized != null:
        return initialized(_that);
      case _accountAdded() when accountAdded != null:
        return accountAdded(_that);
      case _deletingAccount() when deletingAccount != null:
        return deletingAccount(_that);
      case _editAccount() when editAccount != null:
        return editAccount(_that);
      case _goToAddAccountPage() when goToAddAccountPage != null:
        return goToAddAccountPage(_that);
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
    required TResult Function(_accountAdded value) accountAdded,
    required TResult Function(_deletingAccount value) deletingAccount,
    required TResult Function(_editAccount value) editAccount,
    required TResult Function(_goToAddAccountPage value) goToAddAccountPage,
    required TResult Function(_failed value) failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial(_that);
      case _initialized():
        return initialized(_that);
      case _accountAdded():
        return accountAdded(_that);
      case _deletingAccount():
        return deletingAccount(_that);
      case _editAccount():
        return editAccount(_that);
      case _goToAddAccountPage():
        return goToAddAccountPage(_that);
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
    TResult? Function(_accountAdded value)? accountAdded,
    TResult? Function(_deletingAccount value)? deletingAccount,
    TResult? Function(_editAccount value)? editAccount,
    TResult? Function(_goToAddAccountPage value)? goToAddAccountPage,
    TResult? Function(_failed value)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _initialized() when initialized != null:
        return initialized(_that);
      case _accountAdded() when accountAdded != null:
        return accountAdded(_that);
      case _deletingAccount() when deletingAccount != null:
        return deletingAccount(_that);
      case _editAccount() when editAccount != null:
        return editAccount(_that);
      case _goToAddAccountPage() when goToAddAccountPage != null:
        return goToAddAccountPage(_that);
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
    TResult Function()? accountAdded,
    TResult Function()? deletingAccount,
    TResult Function()? editAccount,
    TResult Function()? goToAddAccountPage,
    TResult Function(String errorMsg)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _initialized() when initialized != null:
        return initialized();
      case _accountAdded() when accountAdded != null:
        return accountAdded();
      case _deletingAccount() when deletingAccount != null:
        return deletingAccount();
      case _editAccount() when editAccount != null:
        return editAccount();
      case _goToAddAccountPage() when goToAddAccountPage != null:
        return goToAddAccountPage();
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
    required TResult Function() accountAdded,
    required TResult Function() deletingAccount,
    required TResult Function() editAccount,
    required TResult Function() goToAddAccountPage,
    required TResult Function(String errorMsg) failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial();
      case _initialized():
        return initialized();
      case _accountAdded():
        return accountAdded();
      case _deletingAccount():
        return deletingAccount();
      case _editAccount():
        return editAccount();
      case _goToAddAccountPage():
        return goToAddAccountPage();
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
    TResult? Function()? accountAdded,
    TResult? Function()? deletingAccount,
    TResult? Function()? editAccount,
    TResult? Function()? goToAddAccountPage,
    TResult? Function(String errorMsg)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _initialized() when initialized != null:
        return initialized();
      case _accountAdded() when accountAdded != null:
        return accountAdded();
      case _deletingAccount() when deletingAccount != null:
        return deletingAccount();
      case _editAccount() when editAccount != null:
        return editAccount();
      case _goToAddAccountPage() when goToAddAccountPage != null:
        return goToAddAccountPage();
      case _failed() when failed != null:
        return failed(_that.errorMsg);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _initial with DiagnosticableTreeMixin implements AccountScreenState {
  const _initial();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'AccountScreenState.initial'));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountScreenState.initial()';
  }
}

/// @nodoc

class _initialized with DiagnosticableTreeMixin implements AccountScreenState {
  const _initialized();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'AccountScreenState.initialized'));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountScreenState.initialized()';
  }
}

/// @nodoc

class _accountAdded with DiagnosticableTreeMixin implements AccountScreenState {
  const _accountAdded();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'AccountScreenState.accountAdded'));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountScreenState.accountAdded()';
  }
}

/// @nodoc

class _deletingAccount
    with DiagnosticableTreeMixin
    implements AccountScreenState {
  const _deletingAccount();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'AccountScreenState.deletingAccount'));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountScreenState.deletingAccount()';
  }
}

/// @nodoc

class _editAccount with DiagnosticableTreeMixin implements AccountScreenState {
  const _editAccount();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'AccountScreenState.editAccount'));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountScreenState.editAccount()';
  }
}

/// @nodoc

class _goToAddAccountPage
    with DiagnosticableTreeMixin
    implements AccountScreenState {
  const _goToAddAccountPage();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(
          DiagnosticsProperty('type', 'AccountScreenState.goToAddAccountPage'));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountScreenState.goToAddAccountPage()';
  }
}

/// @nodoc

class _failed with DiagnosticableTreeMixin implements AccountScreenState {
  const _failed({required this.errorMsg});

  final String errorMsg;

  /// Create a copy of AccountScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$failedCopyWith<_failed> get copyWith =>
      __$failedCopyWithImpl<_failed>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'AccountScreenState.failed'))
      ..add(DiagnosticsProperty('errorMsg', errorMsg));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountScreenState.failed(errorMsg: $errorMsg)';
  }
}

/// @nodoc
abstract mixin class _$failedCopyWith<$Res>
    implements $AccountScreenStateCopyWith<$Res> {
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

  /// Create a copy of AccountScreenState
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
