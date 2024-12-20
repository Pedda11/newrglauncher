import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/shared_preferences_settings.dart';
import '../../../repository/main_repository.dart';

part 'settings_screen_state.dart';
part 'settings_screen_cubit.freezed.dart';

class SettingsScreenCubit extends Cubit<SettingsScreenState> {
  final MainRepository mainRepository;
  SettingsScreenCubit(this.mainRepository)
      : super(const SettingsScreenState.initial());

  void changeWowFilePath(String? path) {
    emit(const SettingsScreenState.initial());
    if (path != null) {
      mainRepository.settingsRepository.wowExecutablePath = path;
      SettingsPreferences.setWowPath(path);
      emit(const SettingsScreenState.settingsChanged());
    }
  }

  void changeDataDirectory(String? directoryName) {
    emit(const SettingsScreenState.initial());
    if (directoryName != null) {
      mainRepository.settingsRepository.wowDataDirectory = directoryName;
      SettingsPreferences.setDataDirectory(directoryName);
      emit(const SettingsScreenState.settingsChanged());
    }
  }
}
