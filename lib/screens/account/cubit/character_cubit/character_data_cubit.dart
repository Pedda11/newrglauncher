import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twodotnulllauncher/repository/preferences_repository.dart';
import 'package:twodotnulllauncher/repository/settings_repository.dart';
import '../../../../data/account.dart';
import '../../../../data/altoholic.dart';
import '../../../../helper/error_report_builder.dart';
import '../../../../repository/error_report_repository.dart';
import '../../../../repository/error_repository.dart';
import '../../../../repository/gold_history_repository.dart';
import '../../../../repository/main_repository.dart';
import '../../../../services/account_data_refresh_service.dart';
import '../../../../services/gold_trend/gold_aggregation_service.dart';
import '../../../../services/gold_trend/gold_history_service.dart';
import '../../../../utils/gold_snapshot_builder.dart';
import '../../../../widgets/log.dart';

part 'character_data_state.dart';

part 'character_data_cubit.freezed.dart';

class CharacterDataCubit extends Cubit<CharacterDataState> {
  final MainRepository mainRepository;
  final SettingsRepository settingsRepository;
  final PreferencesRepository preferencesRepository;

  CharacterDataCubit({
    required this.mainRepository,
    required this.settingsRepository,
    required this.preferencesRepository,
  }) : super(const CharacterDataState.initial());

  Future<void> initialize() async {
    emit(const CharacterDataState.initialized());
  }

  Future<void> getAccountDetails(Account acc) async {
    try {
      final refreshService = AccountDataRefreshService(
        mainRepository: mainRepository,
        settingsRepository: settingsRepository,
      );

      final result = await refreshService.refreshAccount(acc);

      emit(
        CharacterDataState.accountLoaded(
          characterList: result.characters,
        ),
      );
    } catch (e, st) {
      await Log.i('Error while reading character data: ${e.toString()}');
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

      emit(CharacterDataState.failed(errorMsg: e.toString()));
    }
  }
}
