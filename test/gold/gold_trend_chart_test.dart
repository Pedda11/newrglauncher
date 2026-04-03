import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twodotnulllauncher/data/gold_chart_point.dart';
import 'package:twodotnulllauncher/screens/gold_trend/widgets/gold_trend_chart_widget.dart';

void main() {
  testWidgets('shows fallback text when no history is available',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GoldTrendChartWidget(
            historyPoints: [],
            forecastPoints: [],
          ),
        ),
      ),
    );

    expect(find.text('No gold history available yet'), findsOneWidget);
  });

  testWidgets('renders chart when history points are available',
      (WidgetTester tester) async {
    final historyPoints = [
      GoldChartPoint(
        date: DateTime(2026, 3, 30),
        gold: 250000,
      ),
      GoldChartPoint(
        date: DateTime(2026, 4, 1),
        gold: 275000,
      ),
      GoldChartPoint(
        date: DateTime(2026, 4, 2),
        gold: 300000,
      ),
    ];

    final forecastPoints = [
      GoldChartPoint(
        date: DateTime(2026, 4, 9),
        gold: 320000,
      ),
      GoldChartPoint(
        date: DateTime(2026, 5, 2),
        gold: 360000,
      ),
      GoldChartPoint(
        date: DateTime(2026, 7, 1),
        gold: 450000,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoldTrendChartWidget(
            historyPoints: historyPoints,
            forecastPoints: forecastPoints,
          ),
        ),
      ),
    );

    expect(find.text('No gold history available yet'), findsNothing);
    expect(find.byType(GoldTrendChartWidget), findsOneWidget);
  });
}
