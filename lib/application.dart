import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/generated/l10n.dart';
import 'screens/splash/splash_screen.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        Localize.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
      ],
      home: SplashScreen(),
    );
  }
}
