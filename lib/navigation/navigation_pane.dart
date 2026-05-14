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
import '../theme/helpers/theme_context_extensions.dart';
import '../widgets/launcher_panel.dart';
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
    await Log.info('_beforeExit');

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
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;
    final List<Widget> screens = [
      const AccountScreen(),
      const EventScreen(),
      const GoldTrendChartScreen(),
      const SettingsScreen(),
    ];
    return MultiBlocProvider(
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
        backgroundColor: colors.windowBackground,
        body: Row(
          children: [
            Container(
                width: 86,
                decoration: BoxDecoration(
                  color: colors.panelBackground.withValues(alpha: 0.92),
                  border: Border(
                    right: BorderSide(
                      color: colors.panelBorder.withValues(alpha: 0.75),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 12,
                      spreadRadius: -6,
                      offset: const Offset(4, 0),
                    ),
                  ],
                ),
                child: NavigationRail(
                  backgroundColor: Colors.transparent,
                  leadingAtTop: true,
                  labelType: NavigationRailLabelType.none,
                  useIndicator: true,
                  indicatorColor: colors.accent.withValues(alpha: 0.18),
                  selectedIconTheme: IconThemeData(
                    color: colors.accentSoft,
                    size: 26,
                  ),
                  unselectedIconTheme: IconThemeData(
                    color: colors.mutedText,
                    size: 24,
                  ),
                  selectedLabelTextStyle: text.hintText.copyWith(
                    color: colors.accentSoft,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelTextStyle: text.hintText.copyWith(
                    color: colors.mutedText,
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.group),
                      label: Text(locales.accountScreenTitle),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.event),
                      label: Text(locales.navigationPaneEventLabel),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.area_chart),
                      label: Text(locales.navigationPaneGoldTrendLabel),
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
                            behavior: SnackBarBehavior.floating,
                            backgroundColor:
                                colors.panelBackground.withValues(alpha: 0.96),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius.card),
                              side: BorderSide(
                                color: colors.errorText.withValues(alpha: 0.28),
                                width: 1,
                              ),
                            ),
                            content: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: colors.errorText,
                                  size: 20,
                                ),
                                SizedBox(width: spacing.md),
                                Expanded(
                                  child: Text(
                                    locales.settingsScreenNotAllSet,
                                    style: text.fieldValue.copyWith(
                                      color: colors.bodyText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
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
                )),
            Expanded(
              child: BlocConsumer<BackupCubit, BackupState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => screens[_selectedIndex],
                    backUpProgress: (processedFiles, totalFiles, progress) {
                      return BackupScreen(
                          processedFiles: processedFiles,
                          totalFiles: totalFiles,
                          progress: progress);
                    },
                    backupFailed: (errorMsg) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(spacing.screenPadding),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 720),
                            child: LauncherPanel(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    size: 36,
                                    color: colors.errorText,
                                  ),
                                  SizedBox(height: spacing.md),
                                  Text(
                                    locales.backupScreenFailed(errorMsg),
                                    style: text.sectionTitle.copyWith(
                                      color: colors.bodyText,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: spacing.sm),
                                  Text(
                                    errorMsg,
                                    style: text.sectionSubtitle.copyWith(
                                      color: colors.mutedText,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
