// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_screen_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsScreenState {
  @override
  String toString() {
    return 'SettingsScreenState()';
  }
}

/// @nodoc
class $SettingsScreenStateCopyWith<$Res> {
  $SettingsScreenStateCopyWith(
      SettingsScreenState _, $Res Function(SettingsScreenState) __);
}

/// Adds pattern-matching-related methods to [SettingsScreenState].
extension SettingsScreenStatePatterns on SettingsScreenState {
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
    TResult Function(_chooseDataFolder value)? chooseDataFolder,
    TResult Function(_changingSettings value)? changingSettings,
    TResult Function(_fileOrDirectoryNotFound value)? fileOrDirectoryNotFound,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _initialized() when initialized != null:
        return initialized(_that);
      case _chooseDataFolder() when chooseDataFolder != null:
        return chooseDataFolder(_that);
      case _changingSettings() when changingSettings != null:
        return changingSettings(_that);
      case _fileOrDirectoryNotFound() when fileOrDirectoryNotFound != null:
        return fileOrDirectoryNotFound(_that);
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
    required TResult Function(_chooseDataFolder value) chooseDataFolder,
    required TResult Function(_changingSettings value) changingSettings,
    required TResult Function(_fileOrDirectoryNotFound value)
        fileOrDirectoryNotFound,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial(_that);
      case _initialized():
        return initialized(_that);
      case _chooseDataFolder():
        return chooseDataFolder(_that);
      case _changingSettings():
        return changingSettings(_that);
      case _fileOrDirectoryNotFound():
        return fileOrDirectoryNotFound(_that);
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
    TResult? Function(_chooseDataFolder value)? chooseDataFolder,
    TResult? Function(_changingSettings value)? changingSettings,
    TResult? Function(_fileOrDirectoryNotFound value)? fileOrDirectoryNotFound,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial(_that);
      case _initialized() when initialized != null:
        return initialized(_that);
      case _chooseDataFolder() when chooseDataFolder != null:
        return chooseDataFolder(_that);
      case _changingSettings() when changingSettings != null:
        return changingSettings(_that);
      case _fileOrDirectoryNotFound() when fileOrDirectoryNotFound != null:
        return fileOrDirectoryNotFound(_that);
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
    TResult Function(List<String> dataFolder)? chooseDataFolder,
    TResult Function()? changingSettings,
    TResult Function()? fileOrDirectoryNotFound,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _initialized() when initialized != null:
        return initialized();
      case _chooseDataFolder() when chooseDataFolder != null:
        return chooseDataFolder(_that.dataFolder);
      case _changingSettings() when changingSettings != null:
        return changingSettings();
      case _fileOrDirectoryNotFound() when fileOrDirectoryNotFound != null:
        return fileOrDirectoryNotFound();
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
    required TResult Function(List<String> dataFolder) chooseDataFolder,
    required TResult Function() changingSettings,
    required TResult Function() fileOrDirectoryNotFound,
  }) {
    final _that = this;
    switch (_that) {
      case _initial():
        return initial();
      case _initialized():
        return initialized();
      case _chooseDataFolder():
        return chooseDataFolder(_that.dataFolder);
      case _changingSettings():
        return changingSettings();
      case _fileOrDirectoryNotFound():
        return fileOrDirectoryNotFound();
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
    TResult? Function(List<String> dataFolder)? chooseDataFolder,
    TResult? Function()? changingSettings,
    TResult? Function()? fileOrDirectoryNotFound,
  }) {
    final _that = this;
    switch (_that) {
      case _initial() when initial != null:
        return initial();
      case _initialized() when initialized != null:
        return initialized();
      case _chooseDataFolder() when chooseDataFolder != null:
        return chooseDataFolder(_that.dataFolder);
      case _changingSettings() when changingSettings != null:
        return changingSettings();
      case _fileOrDirectoryNotFound() when fileOrDirectoryNotFound != null:
        return fileOrDirectoryNotFound();
      case _:
        return null;
    }
  }
}

/// @nodoc

class _initial implements SettingsScreenState {
  const _initial();

  @override
  String toString() {
    return 'SettingsScreenState.initial()';
  }
}

/// @nodoc

class _initialized implements SettingsScreenState {
  const _initialized();

  @override
  String toString() {
    return 'SettingsScreenState.initialized()';
  }
}

/// @nodoc

class _chooseDataFolder implements SettingsScreenState {
  const _chooseDataFolder({required final List<String> dataFolder})
      : _dataFolder = dataFolder;

  final List<String> _dataFolder;
  List<String> get dataFolder {
    if (_dataFolder is EqualUnmodifiableListView) return _dataFolder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dataFolder);
  }

  /// Create a copy of SettingsScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$chooseDataFolderCopyWith<_chooseDataFolder> get copyWith =>
      __$chooseDataFolderCopyWithImpl<_chooseDataFolder>(this, _$identity);

  @override
  String toString() {
    return 'SettingsScreenState.chooseDataFolder(dataFolder: $dataFolder)';
  }
}

/// @nodoc
abstract mixin class _$chooseDataFolderCopyWith<$Res>
    implements $SettingsScreenStateCopyWith<$Res> {
  factory _$chooseDataFolderCopyWith(
          _chooseDataFolder value, $Res Function(_chooseDataFolder) _then) =
      __$chooseDataFolderCopyWithImpl;
  @useResult
  $Res call({List<String> dataFolder});
}

/// @nodoc
class __$chooseDataFolderCopyWithImpl<$Res>
    implements _$chooseDataFolderCopyWith<$Res> {
  __$chooseDataFolderCopyWithImpl(this._self, this._then);

  final _chooseDataFolder _self;
  final $Res Function(_chooseDataFolder) _then;

  /// Create a copy of SettingsScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dataFolder = null,
  }) {
    return _then(_chooseDataFolder(
      dataFolder: null == dataFolder
          ? _self._dataFolder
          : dataFolder // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _changingSettings implements SettingsScreenState {
  const _changingSettings();

  @override
  String toString() {
    return 'SettingsScreenState.changingSettings()';
  }
}

/// @nodoc

class _fileOrDirectoryNotFound implements SettingsScreenState {
  const _fileOrDirectoryNotFound();

  @override
  String toString() {
    return 'SettingsScreenState.fileOrDirectoryNotFound()';
  }
}

// dart format on
