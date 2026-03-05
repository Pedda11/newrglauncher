import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/services/update/launcher_status_api.dart';
import '../../data/launcher_endpoints.dart';
import '../../localization/generated/l10n.dart';
import '../../repository/error_repository.dart';
import '../../repository/main_repository.dart';
import '../../repository/preferences_repository.dart';
import '../../repository/settings_repository.dart';
import 'cubit/splash_screen_cubit.dart';
import 'widgets/splash_screen_content.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainRepository = context.read<MainRepository>();
    final preferencesRepository = context.read<PreferencesRepository>();
    final settingsRepository = context.read<SettingsRepository>();
    final locales = Localize.of(context);
    return BlocProvider(
      create: (context) => SplashScreenCubit(
          mainRepository: mainRepository,
          preferencesRepository: preferencesRepository,
          settingsRepository: settingsRepository,
          launcherStatusApi: LauncherStatusApi(LauncherEndpoints.statusUri))
        ..initialize(),
      child: Scaffold(
        body: Stack(
          children: [
            const SplashScreenContent(),
            BlocBuilder<SplashScreenCubit, SplashScreenState>(
              builder: (context, state) {
                return state.maybeWhen(
                  initial: () => const Center(
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  checkingForUpdates: () {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(locales.updateScreenUpdateCheck),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 120,
                            width: 120,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    );
                  },
                  failed: (errorMsg) {
                    context.read<ErrorRepository>().sendErrorToServer(
                        errorMessage: errorMsg,
                        errorOnPosition: 'SplashScreenContent',
                        errorDateTime: DateTime.now().toString());
                    return AlertDialog(
                      title: Text(locales.error),
                      content: Column(
                        children: [
                          Text(
                            locales.errorHandlingContent,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(errorMsg),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            exit(1);
                          },
                          child: Text(locales.ok),
                        ),
                      ],
                    );
                  },
                  orElse: () {
                    return const Center(
                      child: SizedBox(
                          height: 120,
                          width: 120,
                          child: CircularProgressIndicator()),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
