import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twodotnulllauncher/repository/preferences_repository.dart';
import 'package:twodotnulllauncher/repository/settings_repository.dart';

import '../../../../data/account.dart';
import '../../../../data/altoholic.dart';
import '../../../../data/character.dart';
import '../../../../repository/main_repository.dart';

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
    emit(CharacterDataState.initialized());
  }

  Future<void> getAccountDetails(Account acc) async {
    String charsPath =
        '${settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\Rising-Gods';
    final dir = Directory(charsPath);
    late List<FileSystemEntity> entities;
    try {
      entities = await dir.list().toList();
    } on Exception catch (ex) {
      emit(CharacterDataState.failed(errorMsg: ex.toString()));
      return;
    }

    try {
      for (FileSystemEntity e in entities) {
        //filePaths.add(e.path);
        List<String> splits = e.path.split('\\');
        //fileNames.add(splits[splits.length - 1]);
      }

      String charsPathAltoholic =
          '${settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\SavedVariables\\DataStore_Characters.lua';

      String savedInstancesPathAltoholic =
          '${settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\SavedVariables\\Altoholic.lua';

      /*String charsPathAltoholic =
          'C:\\Users\\Pedda\\OneDrive\\Documents\\24-09-2023_WTF_autoBak\\Account\\FIJETA\\SavedVariables\\DataStore_Characters.lua';

      String savedInstancesPathAltoholic =
          'C:\\Users\\Pedda\\OneDrive\\Documents\\24-09-2023_WTF_autoBak\\Account\\FIJETA\\SavedVariables\\Altoholic.lua';*/

      var altoChars = File(charsPathAltoholic);
      final charData = await altoChars.readAsString();

      var altoInstances = File(savedInstancesPathAltoholic);
      final charInstances = await altoInstances.readAsString();

      mainRepository.accountList
          .firstWhere((element) => element.accountName == acc.accountName)
          .accChars = Altoholic.getCharData(charData, charInstances);
      emit(CharacterDataState.accountLoaded(
          characterList: mainRepository.accountList
              .firstWhere((element) => element.accountName == acc.accountName)
              .accChars));
    } on Exception catch (ex) {
      emit(CharacterDataState.failed(errorMsg: ex.toString()));
    }
  }
}
