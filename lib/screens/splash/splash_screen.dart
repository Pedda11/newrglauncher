import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/repository/preferences_repository.dart';
import '../../../../repository/settings_repository.dart';
import 'cubit/splash_screen_cubit.dart';
import 'widgets/splash_screen_content.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashScreenCubit(
          settingsRepository: context.read<SettingsRepository>(),
          preferencesRepository: context.read<PreferencesRepository>())
        ..initialize(),
      child: const Scaffold(
        body: SplashScreenContent(),
      ),
    );
  }
}
