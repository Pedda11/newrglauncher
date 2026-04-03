import 'package:flutter_test/flutter_test.dart';
import 'package:twodotnulllauncher/helper/gold_chart_axis_helper.dart';

void main() {
  group('GoldChartAxisHelper', () {
    test('expands and rounds axis range sensibly around ~500k', () {
      final rawMinY = 497000.0;
      final rawMaxY = 503000.0;

      final normalizedMinY = rawMinY == rawMaxY ? rawMinY - 1 : rawMinY;
      final normalizedMaxY = rawMinY == rawMaxY ? rawMaxY + 1 : rawMaxY;

      final expandedRange = GoldChartAxisHelper.expandToMinimumVisualRange(
        normalizedMinY,
        normalizedMaxY,
      );

      final expandedMinY = expandedRange.$1;
      final expandedMaxY = expandedRange.$2;

      final interval = GoldChartAxisHelper.calculateNiceInterval(
        expandedMinY,
        expandedMaxY,
      );

      final safeMinY = GoldChartAxisHelper.roundDownToInterval(
        expandedMinY,
        interval,
      );
      final safeMaxY = GoldChartAxisHelper.roundUpToInterval(
        expandedMaxY,
        interval,
      );

      expect(interval, 10000);
      expect(safeMinY, 470000);
      expect(safeMaxY, 530000);
    });

    test('expands and rounds axis range sensibly around ~1k', () {
      final rawMinY = 970.0;
      final rawMaxY = 1030.0;

      final normalizedMinY = rawMinY == rawMaxY ? rawMinY - 1 : rawMinY;
      final normalizedMaxY = rawMinY == rawMaxY ? rawMaxY + 1 : rawMaxY;

      final expandedRange = GoldChartAxisHelper.expandToMinimumVisualRange(
        normalizedMinY,
        normalizedMaxY,
      );

      final expandedMinY = expandedRange.$1;
      final expandedMaxY = expandedRange.$2;

      final interval = GoldChartAxisHelper.calculateNiceInterval(
        expandedMinY,
        expandedMaxY,
      );

      final safeMinY = GoldChartAxisHelper.roundDownToInterval(
        expandedMinY,
        interval,
      );
      final safeMaxY = GoldChartAxisHelper.roundUpToInterval(
        expandedMaxY,
        interval,
      );

      expect(interval, 200);
      expect(safeMinY, 400);
      expect(safeMaxY, 1600);
    });
  });
}
