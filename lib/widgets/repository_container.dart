import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AccountScreenCubit(
                mainRepository: context.read<MainRepository>(),
                preferencesRepository: context.read<PreferencesRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                CharacterDataCubit(context.read<MainRepository>()),
          ),
          BlocProvider(
            create: (context) => SettingsScreenCubit(
                mainRepository: context.read<MainRepository>(),
                preferencesRepository: context.read<PreferencesRepository>()),
          ),
        ],
        child: child,
      ),
    );
  }
}
