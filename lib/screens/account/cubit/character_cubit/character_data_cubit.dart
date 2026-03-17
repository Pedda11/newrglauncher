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
import '../../../../repository/main_repository.dart';
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
    await Log.i('Getting character data for account: ${acc.accId}');
    String charsPath =
        '${settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\Rising-Gods';
    final dir = Directory(charsPath);
    late List<FileSystemEntity> entities;
    try {
      entities = await dir.list().toList();
    } catch (e, st) {
      await Log.i('Error while listing character directories: ${e.toString()}');

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
      return;
    }

    try {
      await Log.i(
          'Found ${entities.length} character directories for account: ${acc.accId}');
      for (FileSystemEntity e in entities) {
        //filePaths.add(e.path);
        List<String> splits = e.path.split('\\');
        //fileNames.add(splits[splits.length - 1]);
      }

      await Log.i(
          'Attempting to read character data from Altoholic saved variables for account: ${acc.accId}');
      String charsPathAltoholic =
          '${settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\SavedVariables\\DataStore_Characters.lua';

      await Log.i(
          'Constructed path for Altoholic character data: $charsPathAltoholic');
      String savedInstancesPathAltoholic =
          '${settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\SavedVariables\\Altoholic.lua';

      /*String charsPathAltoholic =
          'C:\\Users\\Pedda\\OneDrive\\Documents\\24-09-2023_WTF_autoBak\\Account\\FIJETA\\SavedVariables\\DataStore_Characters.lua';

      String savedInstancesPathAltoholic =
          'C:\\Users\\Pedda\\OneDrive\\Documents\\24-09-2023_WTF_autoBak\\Account\\FIJETA\\SavedVariables\\Altoholic.lua';*/

      var altoChars = File(charsPathAltoholic);
      final charData = await altoChars.readAsString();

      await Log.i(
          'Successfully read character data from Altoholic saved variables for account: ${acc.accId}, now reading instance data');
      var altoInstances = File(savedInstancesPathAltoholic);
      final charInstances = await altoInstances.readAsString();

      mainRepository.accountList
          .firstWhere((element) => element.accountName == acc.accountName)
          .accChars = Altoholic.getCharData(charData, charInstances);
      emit(CharacterDataState.accountLoaded(
          characterList: mainRepository.accountList
              .firstWhere((element) => element.accountName == acc.accountName)
              .accChars));
      await Log.i(
          'Finished loading character data for account: ${acc.accId}, total characters loaded: ${mainRepository.accountList.firstWhere((element) => element.accountName == acc.accountName).accChars?.length ?? 0}');
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
