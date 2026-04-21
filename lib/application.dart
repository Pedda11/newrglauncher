import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:twodotnulllauncher/theme/launcher_theme_controller.dart';
import 'localization/generated/l10n.dart';
import 'screens/splash/splash_screen.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.read<LauncherThemeController>();

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeController.theme,
          themeMode: ThemeMode.dark,
          localizationsDelegates: const [
            Localize.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('de', ''),
          ],
          home: const SplashScreen(),
        );
      },
    );
  }
}
