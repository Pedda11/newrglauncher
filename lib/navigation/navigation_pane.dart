import 'package:flutter/material.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_add/account_add_screen.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_list/account_list_page.dart';
import 'package:twodotnulllauncher/screens/settings/settings_screen.dart';

import '../localization/generated/l10n.dart';

class NavigationPane extends StatefulWidget {
  const NavigationPane({super.key});

  @override
  State<NavigationPane> createState() => _NavigationPaneState();
}

class _NavigationPaneState extends State<NavigationPane> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    AccountListPage(),
    //AccountAddScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    return Row(
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
    );
  }
}
