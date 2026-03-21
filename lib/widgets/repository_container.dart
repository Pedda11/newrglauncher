import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twodotnulllauncher/navigation/cubit/backup_cubit.dart';
import 'package:twodotnulllauncher/repository/error_repository.dart';
import 'package:twodotnulllauncher/services/backup/backup_service.dart';
import '../repository/main_repository.dart';
import '../repository/preferences_repository.dart';
import '../repository/settings_repository.dart';
import '../screens/account/cubit/account_cubit/account_screen_cubit.dart';
import '../screens/account/cubit/character_cubit/character_data_cubit.dart';
import '../screens/settings/cubit/settings_screen_cubit.dart';

class RepositoryContainer extends StatelessWidget {
  final Widget child;
  final SharedPreferencesAsync sharedPreferences;

  const RepositoryContainer({
    super.key,
    required this.child,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (context) =>
                  PreferencesRepository(preferences: sharedPreferences)),
          RepositoryProvider(
            create: (context) => MainRepository(),
          ),
          RepositoryProvider(
            create: (context) => SettingsRepository(),
          ),
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => SettingsScreenCubit(
                settingsRepository: context.read<SettingsRepository>(),
                preferencesRepository: context.read<PreferencesRepository>())
              ..initialize(),
            child: child,
          ),
          BlocProvider(
            create: (context) => BackupCubit(
                settingsRepository: context.read<SettingsRepository>(),
                backupService: BackupService()),
          )
        ], child: child));
  }
}
