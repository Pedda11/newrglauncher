import 'package:flutter/material.dart';
import 'package:twodotnulllauncher/screens/gold_trend/widgets/gold_trend_chart_screen_content.dart';
import 'package:twodotnulllauncher/widgets/my_appbar.dart';

class GoldTrendChartScreen extends StatelessWidget {
  const GoldTrendChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppbar(title: 'Gold Trend', centerTitle: true),
      body: GoldTrendChartScreenContent(),
    );
  }
}
