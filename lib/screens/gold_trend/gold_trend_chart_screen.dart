import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/gold_chart_point.dart';
import '../../repository/gold_history_repository.dart';
import '../../services/gold_trend/gold_aggregation_service.dart';

class GoldTrendChartScreen extends StatefulWidget {
  const GoldTrendChartScreen({
    super.key,
  });

  @override
  State<GoldTrendChartScreen> createState() => _GoldTrendChartScreenState();
}

class _GoldTrendChartScreenState extends State<GoldTrendChartScreen> {
  List<GoldChartPoint> historyPoints = [];
  List<GoldChartPoint> forecastPoints = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final snapshots = await GoldHistoryRepository().readSnapshots();

    final goldTimeline =
        GoldAggregationService().buildTotalGoldTimeline(snapshots);

    final dailyGoldTimeline =
        GoldAggregationService().compressTimelineToDailyLastValue(goldTimeline);

    setState(() {
      historyPoints =
          GoldAggregationService().buildChartPoints(dailyGoldTimeline);

      forecastPoints =
          GoldAggregationService().buildForecastPoints(historyPoints);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (historyPoints.isEmpty) {
      return const Center(
        child: Text('No gold history available yet'),
      );
    }

    final allPoints = [...historyPoints, ...forecastPoints];

    final minX = 0.0;
    final maxX = (allPoints.length - 1).toDouble();

    final minY = allPoints.map((e) => e.gold).reduce((a, b) => a < b ? a : b);

    final maxY = allPoints.map((e) => e.gold).reduce((a, b) => a > b ? a : b);

    /// Prevent a flat chart from collapsing visually
    final safeMinY = minY == maxY ? minY - 1 : minY;
    final safeMaxY = minY == maxY ? maxY + 1 : maxY;

    final historySpots = <FlSpot>[];
    for (var i = 0; i < historyPoints.length; i++) {
      historySpots.add(
        FlSpot(i.toDouble(), historyPoints[i].gold),
      );
    }

    final forecastSpots = <FlSpot>[];

    /// Start forecast from the last real history point
    final lastHistoryIndex = historyPoints.length - 1;
    final lastHistoryPoint = historyPoints.last;

    forecastSpots.add(
      FlSpot(lastHistoryIndex.toDouble(), lastHistoryPoint.gold),
    );

    for (var i = 0; i < forecastPoints.length; i++) {
      forecastSpots.add(
        FlSpot(
          (historyPoints.length + i).toDouble(),
          forecastPoints[i].gold,
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: safeMinY,
          maxY: safeMaxY,
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(
            show: true,
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 72,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: _calculateBottomInterval(allPoints.length),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= allPoints.length) {
                    return const SizedBox.shrink();
                  }

                  final point = allPoints[index];

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _formatShortDate(point.date),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: historySpots,
              isCurved: false,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withValues(alpha: 0.08),
              ),
            ),
            LineChartBarData(
              spots: forecastSpots,
              isCurved: false,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              dashArray: const [6, 4],
            ),
          ],
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  if (index < 0 || index >= allPoints.length) {
                    return null;
                  }

                  final point = allPoints[index];
                  final isForecast = index >= historyPoints.length;

                  return LineTooltipItem(
                    '${isForecast ? 'Forecast' : 'History'}\n'
                    '${_formatFullDate(point.date)}\n'
                    '${point.gold.toStringAsFixed(2)} Gold',
                    const TextStyle(fontSize: 12),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  double _calculateBottomInterval(int totalCount) {
    if (totalCount <= 6) {
      return 1;
    }
    if (totalCount <= 12) {
      return 2;
    }
    if (totalCount <= 24) {
      return 4;
    }
    return 7;
  }

  String _formatShortDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.';
  }

  String _formatFullDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }
}
