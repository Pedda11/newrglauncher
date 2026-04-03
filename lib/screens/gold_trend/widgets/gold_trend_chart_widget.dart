import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../data/gold_chart_point.dart';
import 'package:intl/intl.dart';

import '../../../helper/gold_chart_axis_helper.dart';

class GoldTrendChartWidget extends StatelessWidget {
  final List<GoldChartPoint> historyPoints;
  final List<GoldChartPoint> forecastPoints;

  const GoldTrendChartWidget({
    super.key,
    required this.historyPoints,
    required this.forecastPoints,
  });

  @override
  Widget build(BuildContext context) {
    if (historyPoints.isEmpty) {
      return const Center(
        child: Text('No gold history available yet'),
      );
    }

    final allPoints = [...historyPoints, ...forecastPoints];

    final baseDate = historyPoints.first.date;

    final minX = 0.0;
    final maxX = _toDayX(allPoints.last.date, baseDate);

    final rawMinY =
        allPoints.map((e) => e.gold).reduce((a, b) => a < b ? a : b);
    final rawMaxY =
        allPoints.map((e) => e.gold).reduce((a, b) => a > b ? a : b);

    final normalizedMinY = rawMinY == rawMaxY ? rawMinY - 1 : rawMinY;
    final normalizedMaxY = rawMinY == rawMaxY ? rawMaxY + 1 : rawMaxY;

    final expandedRange = GoldChartAxisHelper.expandToMinimumVisualRange(
      normalizedMinY,
      normalizedMaxY,
    );

    final expandedMinY = expandedRange.$1;
    final expandedMaxY = expandedRange.$2;

    final yInterval = GoldChartAxisHelper.calculateNiceInterval(
      expandedMinY,
      expandedMaxY,
    );

    final safeMinY = GoldChartAxisHelper.roundDownToInterval(
      expandedMinY,
      yInterval,
    );

    final safeMaxY = GoldChartAxisHelper.roundUpToInterval(
      expandedMaxY,
      yInterval,
    );

    final historySpots = <FlSpot>[];

    for (final point in historyPoints) {
      historySpots.add(
        FlSpot(_toDayX(point.date, baseDate), point.gold),
      );
    }

    final forecastSpots = <FlSpot>[];

    final lastHistoryPoint = historyPoints.last;
    forecastSpots.add(
      FlSpot(_toDayX(lastHistoryPoint.date, baseDate), lastHistoryPoint.gold),
    );

    for (final point in forecastPoints) {
      forecastSpots.add(
        FlSpot(_toDayX(point.date, baseDate), point.gold),
      );
    }

    final pointByX = <double, GoldChartPoint>{};

    for (final point in historyPoints) {
      pointByX[_toDayX(point.date, baseDate)] = point;
    }

    for (final point in forecastPoints) {
      pointByX[_toDayX(point.date, baseDate)] = point;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
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
          borderData: FlBorderData(show: true),
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
                reservedSize: 56,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _formatGoldAxis(value),
                    style: const TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: _calculateBottomInterval(maxX),
                getTitlesWidget: (value, meta) {
                  final date = baseDate.add(
                    Duration(hours: (value * 24).round()),
                  );

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _formatShortDate(date),
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
                final seenKeys = <String>{};

                return touchedSpots.map((spot) {
                  final duplicateKey = '${spot.x}_${spot.y}';

                  if (seenKeys.contains(duplicateKey)) {
                    return null;
                  }
                  seenKeys.add(duplicateKey);

                  final point = pointByX[spot.x];
                  if (point == null) {
                    return null;
                  }

                  final isForecast = forecastPoints.any(
                    (p) => _toDayX(p.date, baseDate) == spot.x,
                  );

                  return LineTooltipItem(
                    '${isForecast ? 'Forecast' : 'History'}\n'
                    '${_formatFullDate(point.date)}\n'
                    '${_formatGoldTooltip(point.gold)}',
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

  static double _calculateBottomInterval(double maxX) {
    if (maxX <= 7) return 1;
    if (maxX <= 14) return 2;
    if (maxX <= 30) return 5;
    if (maxX <= 60) return 10;
    return 15;
  }

  static String _formatShortDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.';
  }

  static String _formatFullDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

  String _formatGoldTooltip(double goldValue) {
    final formatter = NumberFormat('#,##0.00', 'de_DE');
    return '${formatter.format(goldValue)} Gold';
  }

  double _toDayX(DateTime date, DateTime baseDate) {
    return date.difference(baseDate).inHours / 24.0;
  }

  String _formatGoldAxis(double goldValue) {
    if (goldValue >= 1000) {
      final kValue = goldValue / 1000;
      if (kValue % 1 == 0) {
        return '${kValue.toStringAsFixed(0)}k';
      }
      return '${kValue.toStringAsFixed(1)}k';
    }

    return '${goldValue.toStringAsFixed(0)} G';
  }

  (double, double) _expandToMinimumVisualRange(double minY, double maxY) {
    final range = (maxY - minY).abs();
    final center = (minY + maxY) / 2;

    double minimumRange;

    if (center >= 100000) {
      minimumRange = 50000; // e.g. 350k - 400k
    } else if (center >= 10000) {
      minimumRange = 5000; // e.g. 5k - 10k
    } else if (center >= 1000) {
      minimumRange = 1000;
    } else {
      minimumRange = 100;
    }

    if (range >= minimumRange) {
      return (minY, maxY);
    }

    return (
      center - minimumRange / 2,
      center + minimumRange / 2,
    );
  }
}
