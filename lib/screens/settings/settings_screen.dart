import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/repository/settings_repository.dart';
import '../../repository/main_repository.dart';
import '../../repository/preferences_repository.dart';
import '../../widgets/my_appbar.dart';
import 'cubit/settings_screen_cubit.dart';
import 'widgets/settings_screen_content.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsRepository = context.read<SettingsRepository>();
    final preferencesRepository = context.read<PreferencesRepository>();
    return BlocProvider(
      create: (context) => SettingsScreenCubit(
        settingsRepository: settingsRepository,
        preferencesRepository: preferencesRepository,
      )..initialize(),
      child: Scaffold(
        appBar: MyAppbar(title: 'E I N S T E L L U N G E N'),
        body: Padding(
            padding: EdgeInsets.all(24.0), child: SettingsScreenContent()),
      ),
    );
  }
}
