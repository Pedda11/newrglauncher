import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/navigation/cubit/backup_cubit.dart';
import 'package:twodotnulllauncher/screens/backup/backup_screen.dart';
import 'package:twodotnulllauncher/screens/event/event_screen.dart';
import '../localization/generated/l10n.dart';
import '../repository/credential_repository.dart';
import '../repository/main_repository.dart';
import '../repository/preferences_repository.dart';
import '../repository/settings_repository.dart';
import '../screens/account/account_screen.dart';
import '../screens/account/cubit/account_cubit/account_screen_cubit.dart';
import '../screens/account/cubit/character_cubit/character_data_cubit.dart';
import '../screens/account/pages/account_add/cubit/account_add_page_cubit.dart';
import '../screens/gold_trend/gold_trend_chart_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/log.dart';

class NavigationPane extends StatefulWidget {
  final int initialIndex;

  const NavigationPane({super.key, required this.initialIndex});

  @override
  State<NavigationPane> createState() => _NavigationPaneState();
}

class _NavigationPaneState extends State<NavigationPane> {
  int _selectedIndex = 0;

  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _listener = AppLifecycleListener(
      onExitRequested: () async {
        await _beforeExit();
        return AppExitResponse.cancel;
      },
    );
  }

  Future<void> _beforeExit() async {
    await Log.i('_beforeExit');

    final cubit = context.read<BackupCubit>();
    await cubit.startBackup();

    //exit(0);
  }

  @override
  Widget build(BuildContext context) {
    final mainRepository = context.read<MainRepository>();
    final preferencesRepository = context.read<PreferencesRepository>();
    final settingsRepository = context.read<SettingsRepository>();
    final locales = Localize.of(context);
    final List<Widget> screens = [
      const AccountScreen(),
      const EventScreen(),
      const GoldTrendChartScreen(),
      const SettingsScreen(),
    ];
    return RepositoryProvider(
      create: (context) => CredentialRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AccountScreenCubit(
                mainRepository: context.read<MainRepository>(),
                settingsRepository: settingsRepository,
                preferencesRepository: context.read<PreferencesRepository>()),
          ),
          BlocProvider(
            create: (context) => AccountAddPageCubit(
              mainRepository: mainRepository,
              preferencesRepository: preferencesRepository,
              credentialRepository: context.read<CredentialRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CharacterDataCubit(
              mainRepository: context.read<MainRepository>(),
              settingsRepository: settingsRepository,
              preferencesRepository: preferencesRepository,
            ),
          ),
        ],
        child: Scaffold(
          body: Row(
            children: [
              NavigationRail(
                leadingAtTop: true,
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(Icons.group),
                    label: Text(locales.accountScreenTitle),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.event),
                    label: Text(locales.menuItemSettings),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.area_chart),
                    label: Text(locales.menuItemSettings),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.settings),
                    label: Text(locales.menuItemSettings),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  if (index == 0) {
                    if (settingsRepository.secondsToWaitForGameToStart ==
                            null ||
                        settingsRepository.wowRootFolderPath == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            locales.settingsScreenNotAllSet,
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ),
                      );
                      return;
                    }
                  }
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
              BlocConsumer<BackupCubit, BackupState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => Expanded(child: screens[_selectedIndex]),
                    backUpProgress: (processedFiles, totalFiles, progress) {
                      return Expanded(
                        child: BackupScreen(
                            processedFiles: processedFiles,
                            totalFiles: totalFiles,
                            progress: progress),
                      );
                    },
                    backupFailed: (errorMsg) {
                      return Container(
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            'Backup failed: $errorMsg',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                listener: (context, state) {
                  state.maybeMap(
                      orElse: () {},
                      backupFinished: (value) {
                        exit(0);
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
