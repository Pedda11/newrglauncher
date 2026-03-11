// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_screen_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SplashScreenState implements DiagnosticableTreeMixin {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'SplashScreenState'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SplashScreenState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SplashScreenState()';
  }
}

/// @nodoc
class $SplashScreenStateCopyWith<$Res> {
  $SplashScreenStateCopyWith(
      SplashScreenState _, $Res Function(SplashScreenState) __);
}

/// Adds pattern-matching-related methods to [SplashScreenState].
extension SplashScreenStatePatterns on SplashScreenState {
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
    TResult Function(_eulaNotAccepted value)? eulaNotAccepted,
    TResult Function(_initialized value)? initialized,
    TResult Function(_initializedFirstStart value)? initializedFirstStart,
    TResult Function(_checkingForUpdates value)? checkingForUpdates,
    TResult Function(_maintenance value)? maintenance,
    TResult Function(_blockingError value)? blockingError,
    TResult Function(_updateRequired value)? updateRequired,
    TResult Function(_failed value)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _eulaNotAccepted() when eulaNotAccepted != null:
        return eulaNotAccepted(_that);
      case _initialized() when initialized != null:
        return initialized(_that);
      case _initializedFirstStart() when initializedFirstStart != null:
        return initializedFirstStart(_that);
      case _checkingForUpdates() when checkingForUpdates != null:
        return checkingForUpdates(_that);
      case _maintenance() when maintenance != null:
        return maintenance(_that);
      case _blockingError() when blockingError != null:
        return blockingError(_that);
      case _updateRequired() when updateRequired != null:
        return updateRequired(_that);
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
    required TResult Function(_eulaNotAccepted value) eulaNotAccepted,
    required TResult Function(_initialized value) initialized,
    required TResult Function(_initializedFirstStart value)
        initializedFirstStart,
    required TResult Function(_checkingForUpdates value) checkingForUpdates,
    required TResult Function(_maintenance value) maintenance,
    required TResult Function(_blockingError value) blockingError,
    required TResult Function(_updateRequired value) updateRequired,
    required TResult Function(_failed value) failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial(_that);
      case _eulaNotAccepted():
        return eulaNotAccepted(_that);
      case _initialized():
        return initialized(_that);
      case _initializedFirstStart():
        return initializedFirstStart(_that);
      case _checkingForUpdates():
        return checkingForUpdates(_that);
      case _maintenance():
        return maintenance(_that);
      case _blockingError():
        return blockingError(_that);
      case _updateRequired():
        return updateRequired(_that);
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
    TResult? Function(_eulaNotAccepted value)? eulaNotAccepted,
    TResult? Function(_initialized value)? initialized,
    TResult? Function(_initializedFirstStart value)? initializedFirstStart,
    TResult? Function(_checkingForUpdates value)? checkingForUpdates,
    TResult? Function(_maintenance value)? maintenance,
    TResult? Function(_blockingError value)? blockingError,
    TResult? Function(_updateRequired value)? updateRequired,
    TResult? Function(_failed value)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _eulaNotAccepted() when eulaNotAccepted != null:
        return eulaNotAccepted(_that);
      case _initialized() when initialized != null:
        return initialized(_that);
      case _initializedFirstStart() when initializedFirstStart != null:
        return initializedFirstStart(_that);
      case _checkingForUpdates() when checkingForUpdates != null:
        return checkingForUpdates(_that);
      case _maintenance() when maintenance != null:
        return maintenance(_that);
      case _blockingError() when blockingError != null:
        return blockingError(_that);
      case _updateRequired() when updateRequired != null:
        return updateRequired(_that);
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
    TResult Function()? eulaNotAccepted,
    TResult Function()? initialized,
    TResult Function()? initializedFirstStart,
    TResult Function()? checkingForUpdates,
    TResult Function()? maintenance,
    TResult Function(String message)? blockingError,
    TResult Function(String? message, LauncherStatusData status)?
        updateRequired,
    TResult Function(String errorMsg)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _eulaNotAccepted() when eulaNotAccepted != null:
        return eulaNotAccepted();
      case _initialized() when initialized != null:
        return initialized();
      case _initializedFirstStart() when initializedFirstStart != null:
        return initializedFirstStart();
      case _checkingForUpdates() when checkingForUpdates != null:
        return checkingForUpdates();
      case _maintenance() when maintenance != null:
        return maintenance();
      case _blockingError() when blockingError != null:
        return blockingError(_that.message);
      case _updateRequired() when updateRequired != null:
        return updateRequired(_that.message, _that.status);
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
    required TResult Function() eulaNotAccepted,
    required TResult Function() initialized,
    required TResult Function() initializedFirstStart,
    required TResult Function() checkingForUpdates,
    required TResult Function() maintenance,
    required TResult Function(String message) blockingError,
    required TResult Function(String? message, LauncherStatusData status)
        updateRequired,
    required TResult Function(String errorMsg) failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial();
      case _eulaNotAccepted():
        return eulaNotAccepted();
      case _initialized():
        return initialized();
      case _initializedFirstStart():
        return initializedFirstStart();
      case _checkingForUpdates():
        return checkingForUpdates();
      case _maintenance():
        return maintenance();
      case _blockingError():
        return blockingError(_that.message);
      case _updateRequired():
        return updateRequired(_that.message, _that.status);
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
    TResult? Function()? eulaNotAccepted,
    TResult? Function()? initialized,
    TResult? Function()? initializedFirstStart,
    TResult? Function()? checkingForUpdates,
    TResult? Function()? maintenance,
    TResult? Function(String message)? blockingError,
    TResult? Function(String? message, LauncherStatusData status)?
        updateRequired,
    TResult? Function(String errorMsg)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _eulaNotAccepted() when eulaNotAccepted != null:
        return eulaNotAccepted();
      case _initialized() when initialized != null:
        return initialized();
      case _initializedFirstStart() when initializedFirstStart != null:
        return initializedFirstStart();
      case _checkingForUpdates() when checkingForUpdates != null:
        return checkingForUpdates();
      case _maintenance() when maintenance != null:
        return maintenance();
      case _blockingError() when blockingError != null:
        return blockingError(_that.message);
      case _updateRequired() when updateRequired != null:
        return updateRequired(_that.message, _that.status);
      case _failed() when failed != null:
        return failed(_that.errorMsg);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _initial with DiagnosticableTreeMixin implements SplashScreenState {
  const _initial();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'SplashScreenState.initial'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SplashScreenState.initial()';
  }
}

/// @nodoc

class _eulaNotAccepted
    with DiagnosticableTreeMixin
    implements SplashScreenState {
  const _eulaNotAccepted();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'SplashScreenState.eulaNotAccepted'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _eulaNotAccepted);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SplashScreenState.eulaNotAccepted()';
  }
}

/// @nodoc

class _initialized with DiagnosticableTreeMixin implements SplashScreenState {
  const _initialized();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'SplashScreenState.initialized'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _initialized);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SplashScreenState.initialized()';
  }
}

/// @nodoc

class _initializedFirstStart
    with DiagnosticableTreeMixin
    implements SplashScreenState {
  const _initializedFirstStart();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty(
          'type', 'SplashScreenState.initializedFirstStart'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _initializedFirstStart);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SplashScreenState.initializedFirstStart()';
  }
}

/// @nodoc

class _checkingForUpdates
    with DiagnosticableTreeMixin
    implements SplashScreenState {
  const _checkingForUpdates();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(
          DiagnosticsProperty('type', 'SplashScreenState.checkingForUpdates'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _checkingForUpdates);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SplashScreenState.checkingForUpdates()';
  }
}

/// @nodoc

class _maintenance with DiagnosticableTreeMixin implements SplashScreenState {
  const _maintenance();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'SplashScreenState.maintenance'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _maintenance);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SplashScreenState.maintenance()';
  }
}

/// @nodoc

class _blockingError with DiagnosticableTreeMixin implements SplashScreenState {
  const _blockingError({required this.message});

  final String message;

  /// Create a copy of SplashScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$blockingErrorCopyWith<_blockingError> get copyWith =>
      __$blockingErrorCopyWithImpl<_blockingError>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'SplashScreenState.blockingError'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _blockingError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SplashScreenState.blockingError(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$blockingErrorCopyWith<$Res>
    implements $SplashScreenStateCopyWith<$Res> {
  factory _$blockingErrorCopyWith(
          _blockingError value, $Res Function(_blockingError) _then) =
      __$blockingErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$blockingErrorCopyWithImpl<$Res>
    implements _$blockingErrorCopyWith<$Res> {
  __$blockingErrorCopyWithImpl(this._self, this._then);

  final _blockingError _self;
  final $Res Function(_blockingError) _then;

  /// Create a copy of SplashScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_blockingError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _updateRequired
    with DiagnosticableTreeMixin
    implements SplashScreenState {
  const _updateRequired({this.message, required this.status});

  final String? message;
  final LauncherStatusData status;

  /// Create a copy of SplashScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$updateRequiredCopyWith<_updateRequired> get copyWith =>
      __$updateRequiredCopyWithImpl<_updateRequired>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'SplashScreenState.updateRequired'))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('status', status));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _updateRequired &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, status);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SplashScreenState.updateRequired(message: $message, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$updateRequiredCopyWith<$Res>
    implements $SplashScreenStateCopyWith<$Res> {
  factory _$updateRequiredCopyWith(
          _updateRequired value, $Res Function(_updateRequired) _then) =
      __$updateRequiredCopyWithImpl;
  @useResult
  $Res call({String? message, LauncherStatusData status});
}

/// @nodoc
class __$updateRequiredCopyWithImpl<$Res>
    implements _$updateRequiredCopyWith<$Res> {
  __$updateRequiredCopyWithImpl(this._self, this._then);

  final _updateRequired _self;
  final $Res Function(_updateRequired) _then;

  /// Create a copy of SplashScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
    Object? status = null,
  }) {
    return _then(_updateRequired(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as LauncherStatusData,
    ));
  }
}

/// @nodoc

class _failed with DiagnosticableTreeMixin implements SplashScreenState {
  const _failed({required this.errorMsg});

  final String errorMsg;

  /// Create a copy of SplashScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$failedCopyWith<_failed> get copyWith =>
      __$failedCopyWithImpl<_failed>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'SplashScreenState.failed'))
      ..add(DiagnosticsProperty('errorMsg', errorMsg));
  }

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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SplashScreenState.failed(errorMsg: $errorMsg)';
  }
}

/// @nodoc
abstract mixin class _$failedCopyWith<$Res>
    implements $SplashScreenStateCopyWith<$Res> {
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

  /// Create a copy of SplashScreenState
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
