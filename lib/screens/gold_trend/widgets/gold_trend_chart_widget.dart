import '../../../helper/gold_chart_axis_helper.dart';
import '../../../localization/generated/l10n.dart';
import '../../../data/gold_chart_point.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/helpers/theme_context_extensions.dart';

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
    final locales = Localize.of(context);
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;
    if (historyPoints.length < 2) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: EdgeInsets.all(spacing.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius.card),
            color: colors.inputBackground.withValues(alpha: 0.72),
            border: Border.all(
              color: colors.accent.withValues(alpha: 0.14),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 14,
                spreadRadius: -6,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.show_chart_rounded,
                size: 34,
                color: colors.accentSoft,
              ),
              SizedBox(height: spacing.md),
              Text(
                locales.goldTrendChartNoHistory,
                style: text.sectionTitle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.md),
              Text(
                locales.goldTrendChartNoHistoryDescription,
                style: text.sectionSubtitle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.sm),
              Text(
                locales.goldTrendChartMinimumDataPoints,
                style: text.hintText,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.xs),
              Text(
                locales.goldTrendChartDataImprovement,
                style: text.hintText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: spacing.sm,
            right: spacing.sm,
            bottom: spacing.lg,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locales.goldTrendScreenTitle,
                      style: text.sectionTitle,
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      '${locales.goldTrendChartHistory} / ${locales.goldTrendChartForecast}',
                      style: text.sectionSubtitle.copyWith(
                        color: colors.mutedText.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.sm,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius.button),
                  color: colors.inputBackground.withValues(alpha: 0.72),
                  border: Border.all(
                    color: colors.accent.withValues(alpha: 0.14),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 18,
                          height: 3,
                          decoration: BoxDecoration(
                            color: colors.accentStrong,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        SizedBox(width: spacing.sm),
                        Text(
                          locales.goldTrendChartHistory,
                          style: text.hintText.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: spacing.md),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 3,
                              decoration: BoxDecoration(
                                color:
                                    colors.accentSoft.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Container(
                              width: 6,
                              height: 3,
                              decoration: BoxDecoration(
                                color:
                                    colors.accentSoft.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Container(
                              width: 6,
                              height: 3,
                              decoration: BoxDecoration(
                                color:
                                    colors.accentSoft.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: spacing.sm),
                        Text(
                          locales.goldTrendChartForecast,
                          style: text.hintText.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius.card),
              color: colors.panelBackground.withValues(alpha: 0.78),
              border: Border.all(
                color: colors.accent.withValues(alpha: 0.14),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 14,
                  spreadRadius: -6,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.lg,
                spacing.lg,
                spacing.md,
              ),
              child: LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
                  minY: safeMinY,
                  maxY: safeMaxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: yInterval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colors.panelBorder.withValues(alpha: 0.30),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(
                        color: colors.panelBorder.withValues(alpha: 0.65),
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: colors.panelBorder.withValues(alpha: 0.65),
                        width: 1,
                      ),
                      top: BorderSide.none,
                      right: BorderSide.none,
                    ),
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
                        reservedSize: 40,
                        interval: _calculateBottomInterval(maxX),
                        getTitlesWidget: (value, meta) {
                          final date = baseDate.add(
                            Duration(hours: (value * 24).round()),
                          );

                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              _formatShortDate(date),
                              style: text.hintText.copyWith(
                                fontSize: 10,
                                color: colors.mutedText.withValues(alpha: 0.82),
                              ),
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
                      barWidth: 3,
                      color: colors.accentStrong,
                      dotData: FlDotData(
                        show: true,
                        checkToShowDot: (spot, barData) {
                          return spot == historySpots.last;
                        },
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4.8,
                            color: colors.accentStrong,
                            strokeWidth: 2.2,
                            strokeColor: colors.panelBackground,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colors.accent.withValues(alpha: 0.20),
                            colors.accent.withValues(alpha: 0.06),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    LineChartBarData(
                      spots: forecastSpots,
                      isCurved: false,
                      barWidth: 2.5,
                      color: colors.accentSoft.withValues(alpha: 0.85),
                      dotData: FlDotData(
                        show: true,
                        checkToShowDot: (spot, barData) {
                          return spot == forecastSpots.last;
                        },
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4.4,
                            color: colors.accentSoft.withValues(alpha: 0.95),
                            strokeWidth: 2,
                            strokeColor: colors.panelBackground,
                          );
                        },
                      ),
                      dashArray: const [8, 5],
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBorderRadius: BorderRadius.circular(radius.input),
                      tooltipPadding: EdgeInsets.symmetric(
                        horizontal: spacing.md,
                        vertical: spacing.sm,
                      ),
                      tooltipMargin: 12,
                      getTooltipColor: (_) =>
                          colors.panelBackground.withValues(alpha: 0.96),
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
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
                            '${isForecast ? locales.goldTrendChartForecast : locales.goldTrendChartHistory}\n'
                            '${_formatFullDate(point.date)}\n'
                            '${_formatGoldTooltip(point.gold, locales)}',
                            text.fieldValue.copyWith(
                              fontSize: 12,
                              height: 1.35,
                              color: isForecast
                                  ? colors.accentSoft
                                  : colors.bodyText,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static double _calculateBottomInterval(double maxX) {
    if (maxX <= 7) return 1;
    if (maxX <= 14) return 3;
    if (maxX <= 30) return 6;
    if (maxX <= 60) return 12;
    return 18;
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

  String _formatGoldTooltip(double goldValue, Localize locales) {
    final formatter = NumberFormat('#,##0.00', 'de_DE');
    return '${formatter.format(goldValue)} ${locales.goldTrendChartGoldUnit}';
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
