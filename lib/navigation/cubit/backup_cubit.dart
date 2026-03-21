import 'package:freezed_annotation/freezed_annotation.dart';
import '../../repository/settings_repository.dart';
import '../../services/backup/backup_service.dart';
import 'package:path/path.dart' as p;
import 'package:bloc/bloc.dart';

part 'backup_state.dart';

part 'backup_cubit.freezed.dart';

class BackupCubit extends Cubit<BackupState> {
  final SettingsRepository settingsRepository;
  final BackupService backupService;

  BackupCubit({
    required this.settingsRepository,
    required this.backupService,
  }) : super(const BackupState.initial());

  Future<void> startBackup() async {
    if (settingsRepository.wowAccountsDirectoryPath == null ||
        settingsRepository.wowRootFolderPath == null) {
      return;
    }

    try {
      emit(const BackupState.backUpStarted());

      await backupService.createBackup(
        sourceFolderPath: settingsRepository.wowAccountsDirectoryPath!,
        backupFolderPath: p.join(
          settingsRepository.wowRootFolderPath!,
          'Backups',
        ),
        onProgress: (progress) {
          emit(
            BackupState.backUpProgress(
              processedFiles: progress.processedFiles,
              totalFiles: progress.totalFiles,
              progress: progress.progress,
            ),
          );
        },
      );

      emit(const BackupState.backupFinished());

      emit(const BackupState.backupFinished());
    } catch (e) {
      emit(BackupState.backupFailed(errorMsg: e.toString()));
    }
  }
}
