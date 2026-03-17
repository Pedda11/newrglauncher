part of 'backup_cubit.dart';

@freezed
class BackupState with _$BackupState {
  const factory BackupState.initial() = _initial;

  const factory BackupState.backUpStarted() = _backUpStarted;

  const factory BackupState.backupFinished() = _backupFinished;

  const factory BackupState.backupFailed({required String errorMsg}) =
      _backupFailed;
}
