import 'package:flutter/material.dart';
import 'package:twodotnulllauncher/screens/gold_trend/widgets/gold_trend_chart_screen_content.dart';
import 'package:twodotnulllauncher/widgets/my_appbar.dart';
import 'package:twodotnulllauncher/localization/generated/l10n.dart';

class GoldTrendChartScreen extends StatelessWidget {
  const GoldTrendChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    return Scaffold(
      appBar: MyAppbar(title: locales.goldTrendScreenTitle, centerTitle: true),
      body: const GoldTrendChartScreenContent(),
    );
  }
}
