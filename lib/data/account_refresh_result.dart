import 'character.dart';
import 'gold_chart_point.dart';

class AccountRefreshResult {
  final List<Character> characters;
  final int totalGoldCopper;
  final List<GoldChartPoint> chartPoints;
  final List<GoldChartPoint> forecastPoints;

  AccountRefreshResult({
    required this.characters,
    required this.totalGoldCopper,
    required this.chartPoints,
    required this.forecastPoints,
  });
}
