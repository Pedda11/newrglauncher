import 'package:freezed_annotation/freezed_annotation.dart';
import '../../helper/error_report_builder.dart';
import '../../repository/error_report_repository.dart';
import '../../repository/error_repository.dart';
import '../../repository/settings_repository.dart';
import '../../services/backup/backup_service.dart';
import 'package:path/path.dart' as p;
import 'package:bloc/bloc.dart';

import '../../widgets/log.dart';

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

      await Log.i('Backup finished.');

      emit(const BackupState.backupFinished());
    } catch (e, st) {
      await Log.i('Backup failed: $e');
      final logTail = await LogReader.readLastLines(10);

      final report = await LauncherErrorReportBuilder.build(
        errorMessage: e.toString(),
        stackTrace: st.toString(),
        logTail: logTail,
      );

      await ErrorReportRepository().uploadErrorReport(
        app: 'launcher',
        report: report,
      );

      emit(BackupState.backupFailed(errorMsg: e.toString()));
    }
  }
}
