import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/account.dart';
import '../../../../data/altoholic.dart';
import '../../../../data/character.dart';
import '../../../../repository/main_repository.dart';

part 'character_data_state.dart';
part 'character_data_cubit.freezed.dart';

class CharacterDataCubit extends Cubit<CharacterDataState> {
  final MainRepository mainRepository;
  CharacterDataCubit(this.mainRepository)
      : super(const CharacterDataState.initial());

  getAccountDetails(Account acc) async {
    //filePaths.clear();
    //fileNames.clear();
    String charsPath =
        '${mainRepository.settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\Rising-Gods';
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
          '${mainRepository.settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\SavedVariables\\DataStore_Characters.lua';

      String savedInstancesPathAltoholic =
          '${mainRepository.settingsRepository.wowAccountsDirectoryPath}\\${acc.accountName.toUpperCase()}\\SavedVariables\\Altoholic.lua';

      /*String charsPathAltoholic =
          'C:\\Users\\Pedda\\OneDrive\\Documents\\24-09-2023_WTF_autoBak\\Account\\FIJETA\\SavedVariables\\DataStore_Characters.lua';

      String savedInstancesPathAltoholic =
          'C:\\Users\\Pedda\\OneDrive\\Documents\\24-09-2023_WTF_autoBak\\Account\\FIJETA\\SavedVariables\\Altoholic.lua';*/

      var altoChars = File(charsPathAltoholic);
      final charData = await altoChars.readAsString();

      var altoInstances = File(savedInstancesPathAltoholic);
      final charInstances = await altoInstances.readAsString();

      mainRepository.accountList
          ?.firstWhere((element) => element.accountName == acc.accountName)
          .accChars = Altoholic.getCharData(charData, charInstances);
      emit(CharacterDataState.initialized(
          characterList: mainRepository.accountList!
              .firstWhere((element) => element.accountName == acc.accountName)
              .accChars));
    } on Exception catch (ex) {
      emit(CharacterDataState.failed(errorMsg: ex.toString()));
    }
  }
}
