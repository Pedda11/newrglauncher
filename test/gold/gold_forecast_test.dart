import 'package:flutter_test/flutter_test.dart';
import 'package:twodotnulllauncher/data/gold_chart_point.dart';
import 'package:twodotnulllauncher/services/gold_trend/gold_aggregation_service.dart';

void main() {
  test('forecast builds 3 future points from valid chart points', () {
    final aggregationService = GoldAggregationService();

    final chartPoints = [
      GoldChartPoint(
        date: DateTime(2026, 3, 5),
        gold: 100000,
      ),
      GoldChartPoint(
        date: DateTime(2026, 3, 12),
        gold: 110000,
      ),
      GoldChartPoint(
        date: DateTime(2026, 3, 19),
        gold: 125000,
      ),
      GoldChartPoint(
        date: DateTime(2026, 3, 26),
        gold: 140000,
      ),
      GoldChartPoint(
        date: DateTime(2026, 4, 2),
        gold: 155000,
      ),
    ];

    final forecastPoints = aggregationService.buildForecastPoints(chartPoints);

    expect(forecastPoints.length, 3);

    final lastHistoryDate = chartPoints.last.date;

    expect(
      forecastPoints[0].date.difference(lastHistoryDate).inDays,
      7,
    );
    expect(
      forecastPoints[1].date.difference(lastHistoryDate).inDays,
      30,
    );
    expect(
      forecastPoints[2].date.difference(lastHistoryDate).inDays,
      90,
    );
  });
}
