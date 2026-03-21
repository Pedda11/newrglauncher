// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BackupState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BackupState()';
  }
}

/// @nodoc
class $BackupStateCopyWith<$Res> {
  $BackupStateCopyWith(BackupState _, $Res Function(BackupState) __);
}

/// Adds pattern-matching-related methods to [BackupState].
extension BackupStatePatterns on BackupState {
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
    TResult Function(_backUpStarted value)? backUpStarted,
    TResult Function(_backUpProgress value)? backUpProgress,
    TResult Function(_finalizing value)? finalizing,
    TResult Function(_backupFinished value)? backupFinished,
    TResult Function(_backupFailed value)? backupFailed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _backUpStarted() when backUpStarted != null:
        return backUpStarted(_that);
      case _backUpProgress() when backUpProgress != null:
        return backUpProgress(_that);
      case _finalizing() when finalizing != null:
        return finalizing(_that);
      case _backupFinished() when backupFinished != null:
        return backupFinished(_that);
      case _backupFailed() when backupFailed != null:
        return backupFailed(_that);
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
    required TResult Function(_backUpStarted value) backUpStarted,
    required TResult Function(_backUpProgress value) backUpProgress,
    required TResult Function(_finalizing value) finalizing,
    required TResult Function(_backupFinished value) backupFinished,
    required TResult Function(_backupFailed value) backupFailed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial(_that);
      case _backUpStarted():
        return backUpStarted(_that);
      case _backUpProgress():
        return backUpProgress(_that);
      case _finalizing():
        return finalizing(_that);
      case _backupFinished():
        return backupFinished(_that);
      case _backupFailed():
        return backupFailed(_that);
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
    TResult? Function(_backUpStarted value)? backUpStarted,
    TResult? Function(_backUpProgress value)? backUpProgress,
    TResult? Function(_finalizing value)? finalizing,
    TResult? Function(_backupFinished value)? backupFinished,
    TResult? Function(_backupFailed value)? backupFailed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _backUpStarted() when backUpStarted != null:
        return backUpStarted(_that);
      case _backUpProgress() when backUpProgress != null:
        return backUpProgress(_that);
      case _finalizing() when finalizing != null:
        return finalizing(_that);
      case _backupFinished() when backupFinished != null:
        return backupFinished(_that);
      case _backupFailed() when backupFailed != null:
        return backupFailed(_that);
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
    TResult Function()? backUpStarted,
    TResult Function(int processedFiles, int totalFiles, double progress)?
        backUpProgress,
    TResult Function()? finalizing,
    TResult Function()? backupFinished,
    TResult Function(String errorMsg)? backupFailed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _backUpStarted() when backUpStarted != null:
        return backUpStarted();
      case _backUpProgress() when backUpProgress != null:
        return backUpProgress(
            _that.processedFiles, _that.totalFiles, _that.progress);
      case _finalizing() when finalizing != null:
        return finalizing();
      case _backupFinished() when backupFinished != null:
        return backupFinished();
      case _backupFailed() when backupFailed != null:
        return backupFailed(_that.errorMsg);
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
    required TResult Function() backUpStarted,
    required TResult Function(
            int processedFiles, int totalFiles, double progress)
        backUpProgress,
    required TResult Function() finalizing,
    required TResult Function() backupFinished,
    required TResult Function(String errorMsg) backupFailed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial();
      case _backUpStarted():
        return backUpStarted();
      case _backUpProgress():
        return backUpProgress(
            _that.processedFiles, _that.totalFiles, _that.progress);
      case _finalizing():
        return finalizing();
      case _backupFinished():
        return backupFinished();
      case _backupFailed():
        return backupFailed(_that.errorMsg);
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
    TResult? Function()? backUpStarted,
    TResult? Function(int processedFiles, int totalFiles, double progress)?
        backUpProgress,
    TResult? Function()? finalizing,
    TResult? Function()? backupFinished,
    TResult? Function(String errorMsg)? backupFailed,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _backUpStarted() when backUpStarted != null:
        return backUpStarted();
      case _backUpProgress() when backUpProgress != null:
        return backUpProgress(
            _that.processedFiles, _that.totalFiles, _that.progress);
      case _finalizing() when finalizing != null:
        return finalizing();
      case _backupFinished() when backupFinished != null:
        return backupFinished();
      case _backupFailed() when backupFailed != null:
        return backupFailed(_that.errorMsg);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _initial implements BackupState {
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
    return 'BackupState.initial()';
  }
}

/// @nodoc

class _backUpStarted implements BackupState {
  const _backUpStarted();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _backUpStarted);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BackupState.backUpStarted()';
  }
}

/// @nodoc

class _backUpProgress implements BackupState {
  const _backUpProgress(
      {required this.processedFiles,
      required this.totalFiles,
      required this.progress});

  final int processedFiles;
  final int totalFiles;
  final double progress;

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$backUpProgressCopyWith<_backUpProgress> get copyWith =>
      __$backUpProgressCopyWithImpl<_backUpProgress>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _backUpProgress &&
            (identical(other.processedFiles, processedFiles) ||
                other.processedFiles == processedFiles) &&
            (identical(other.totalFiles, totalFiles) ||
                other.totalFiles == totalFiles) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, processedFiles, totalFiles, progress);

  @override
  String toString() {
    return 'BackupState.backUpProgress(processedFiles: $processedFiles, totalFiles: $totalFiles, progress: $progress)';
  }
}

/// @nodoc
abstract mixin class _$backUpProgressCopyWith<$Res>
    implements $BackupStateCopyWith<$Res> {
  factory _$backUpProgressCopyWith(
          _backUpProgress value, $Res Function(_backUpProgress) _then) =
      __$backUpProgressCopyWithImpl;
  @useResult
  $Res call({int processedFiles, int totalFiles, double progress});
}

/// @nodoc
class __$backUpProgressCopyWithImpl<$Res>
    implements _$backUpProgressCopyWith<$Res> {
  __$backUpProgressCopyWithImpl(this._self, this._then);

  final _backUpProgress _self;
  final $Res Function(_backUpProgress) _then;

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? processedFiles = null,
    Object? totalFiles = null,
    Object? progress = null,
  }) {
    return _then(_backUpProgress(
      processedFiles: null == processedFiles
          ? _self.processedFiles
          : processedFiles // ignore: cast_nullable_to_non_nullable
              as int,
      totalFiles: null == totalFiles
          ? _self.totalFiles
          : totalFiles // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _finalizing implements BackupState {
  const _finalizing();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _finalizing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BackupState.finalizing()';
  }
}

/// @nodoc

class _backupFinished implements BackupState {
  const _backupFinished();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _backupFinished);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BackupState.backupFinished()';
  }
}

/// @nodoc

class _backupFailed implements BackupState {
  const _backupFailed({required this.errorMsg});

  final String errorMsg;

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$backupFailedCopyWith<_backupFailed> get copyWith =>
      __$backupFailedCopyWithImpl<_backupFailed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _backupFailed &&
            (identical(other.errorMsg, errorMsg) ||
                other.errorMsg == errorMsg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMsg);

  @override
  String toString() {
    return 'BackupState.backupFailed(errorMsg: $errorMsg)';
  }
}

/// @nodoc
abstract mixin class _$backupFailedCopyWith<$Res>
    implements $BackupStateCopyWith<$Res> {
  factory _$backupFailedCopyWith(
          _backupFailed value, $Res Function(_backupFailed) _then) =
      __$backupFailedCopyWithImpl;
  @useResult
  $Res call({String errorMsg});
}

/// @nodoc
class __$backupFailedCopyWithImpl<$Res>
    implements _$backupFailedCopyWith<$Res> {
  __$backupFailedCopyWithImpl(this._self, this._then);

  final _backupFailed _self;
  final $Res Function(_backupFailed) _then;

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? errorMsg = null,
  }) {
    return _then(_backupFailed(
      errorMsg: null == errorMsg
          ? _self.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
