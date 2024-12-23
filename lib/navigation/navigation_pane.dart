import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../localization/generated/l10n.dart';
import '../repository/main_repository.dart';
import '../repository/preferences_repository.dart';
import '../repository/settings_repository.dart';
import '../screens/account/account_screen.dart';
import '../screens/account/cubit/account_cubit/account_screen_cubit.dart';
import '../screens/account/cubit/character_cubit/character_data_cubit.dart';
import '../screens/account/pages/account_add/cubit/account_add_page_cubit.dart';
import '../screens/settings/cubit/settings_screen_cubit.dart';
import '../screens/settings/settings_screen.dart';

class NavigationPane extends StatefulWidget {
  const NavigationPane({super.key});

  @override
  State<NavigationPane> createState() => _NavigationPaneState();
}

class _NavigationPaneState extends State<NavigationPane> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    AccountScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final mainRepository = context.read<MainRepository>();
    final preferencesRepository = context.read<PreferencesRepository>();
    final settingsRepository = context.read<SettingsRepository>();
    final locales = Localize.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AccountAddPageCubit(
            mainRepository: mainRepository,
            preferencesRepository: preferencesRepository,
          ),
        ),
        BlocProvider(
          create: (context) => CharacterDataCubit(
            mainRepository: context.read<MainRepository>(),
            settingsRepository: context.read<SettingsRepository>(),
            preferencesRepository: preferencesRepository,
          ),
        ),
      ],
      child: Row(
        children: [
          NavigationRail(
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.group),
                label: Text(locales.accountScreenTitle),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text(locales.menuItemSettings),
              ),
            ],
            selectedIndex: 0,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(child: screens[_selectedIndex]),
        ],
      ),
    );
  }
}
