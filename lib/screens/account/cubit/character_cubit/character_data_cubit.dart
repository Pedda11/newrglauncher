import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twodotnulllauncher/repository/preferences_repository.dart';
import 'package:twodotnulllauncher/repository/settings_repository.dart';
import '../../../../data/account.dart';
import '../../../../data/character.dart';
import '../../../../helper/error_report_builder.dart';
import '../../../../repository/error_report_repository.dart';
import '../../../../repository/error_repository.dart';
import '../../../../repository/main_repository.dart';
import '../../../../services/account_data_refresh_service.dart';
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

      /// Persist updated account data including merged character metadata.
      final accStringList = mainRepository.accountList
          .map((account) => jsonEncode(account.toJson()))
          .toList();

      await preferencesRepository.setAccounts(accStringList);

      emit(
        CharacterDataState.accountLoaded(
          account: acc,
          characterList: result.characters,
        ),
      );
    } on PathNotFoundException catch (e) {
      await Log.i('Error while reading character data: ${e.toString()}');
      return;
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

  Future<void> reorderCharacters(
      Account acc, int oldIndex, int newIndex) async {
    try {
      final accountInList = mainRepository.accountList.firstWhere(
        (element) => element.uniqueId == acc.uniqueId,
      );

      final characters = List<Character>.from(accountInList.accChars ?? []);

      if (characters.isEmpty) {
        return;
      }

      /// ReorderableListView shifts the target index when moving down.
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final movedCharacter = characters.removeAt(oldIndex);
      characters.insert(newIndex, movedCharacter);

      /// Rebuild stable sort indexes after manual reorder.
      for (int i = 0; i < characters.length; i++) {
        characters[i].sortIndex = i;
      }

      accountInList.accChars = characters;

      final accStringList = mainRepository.accountList
          .map((account) => jsonEncode(account.toJson()))
          .toList();

      await preferencesRepository.setAccounts(accStringList);

      emit(
        CharacterDataState.accountLoaded(
          account: acc,
          characterList: characters,
        ),
      );
    } catch (e, st) {
      await Log.i('Error while reordering character data: ${e.toString()}');
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
