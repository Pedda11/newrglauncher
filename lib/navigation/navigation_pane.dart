import 'package:flutter/material.dart';
import '../localization/generated/l10n.dart';
import '../screens/account/account_screen.dart';
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
