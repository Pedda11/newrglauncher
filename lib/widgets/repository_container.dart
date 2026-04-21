import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twodotnulllauncher/navigation/cubit/backup_cubit.dart';
import 'package:twodotnulllauncher/repository/credential_repository.dart';
import 'package:twodotnulllauncher/services/backup/backup_service.dart';
import '../repository/main_repository.dart';
import '../repository/preferences_repository.dart';
import '../repository/settings_repository.dart';
import '../screens/settings/cubit/settings_screen_cubit.dart';
import '../theme/launcher_theme_controller.dart';
import 'package:provider/provider.dart';

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
          create: (context) => CredentialRepository(),
        ),
        RepositoryProvider(
          create: (context) =>
              PreferencesRepository(preferences: sharedPreferences),
        ),
        RepositoryProvider(
          create: (context) => MainRepository(),
        ),
        RepositoryProvider(
          create: (context) => SettingsRepository(),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => LauncherThemeController(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SettingsScreenCubit(
                settingsRepository: context.read<SettingsRepository>(),
                preferencesRepository: context.read<PreferencesRepository>(),
                credentialRepository: context.read<CredentialRepository>(),
              )..initialize(),
            ),
            BlocProvider(
              create: (context) => BackupCubit(
                settingsRepository: context.read<SettingsRepository>(),
                backupService: BackupService(),
              ),
            ),
          ],
          child: child,
        ),
      ),
    );
  }
}
