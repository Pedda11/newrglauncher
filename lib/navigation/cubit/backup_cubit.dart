import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_state.dart';

part 'backup_cubit.freezed.dart';

class BackupCubit extends Cubit<BackupState> {
  BackupCubit() : super(const BackupState.initial());

  Future<void> startBackup() async {
    emit(const BackupState.backUpStarted());
    // Simulate backup process
    await Future.delayed(const Duration(milliseconds: 100));
    // For demonstration, we assume the backup is always successful
    emit(const BackupState.backupFinished());
  }
}
