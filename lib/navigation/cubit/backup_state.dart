part of 'backup_cubit.dart';

@freezed
class BackupState with _$BackupState {
  const factory BackupState.initial() = _initial;

  const factory BackupState.backUpStarted() = _backUpStarted;

  const factory BackupState.backUpProgress(
      {required int processedFiles,
      required int totalFiles,
      required double progress}) = _backUpProgress;

  const factory BackupState.finalizing() = _finalizing;

  const factory BackupState.backupFinished() = _backupFinished;

  const factory BackupState.backupFailed({required String errorMsg}) =
      _backupFailed;
}
