import 'package:flutter/material.dart';
import '../../localization/generated/l10n.dart';
import '../../theme/helpers/theme_context_extensions.dart';
import '../../widgets/my_appbar.dart';
import 'widgets/settings_screen_content.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);

    return Scaffold(
      appBar: MyAppbar(title: locales.settingsScreenTitle),
      body: const SettingsScreenContent(),
    );
  }
}
