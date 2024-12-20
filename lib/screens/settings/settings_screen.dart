import 'package:flutter/material.dart';
import '../../widgets/my_appbar.dart';
import 'widgets/settings_screen_content.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: MyAppbar(title: 'E I N S T E L L U N G E N'),
      body: Padding(
          padding: EdgeInsets.all(24.0), child: SettingsScreenContent()),
    );
  }
}
