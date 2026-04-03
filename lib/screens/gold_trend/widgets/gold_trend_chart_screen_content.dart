import 'package:flutter/material.dart';
import 'package:twodotnulllauncher/screens/gold_trend/widgets/gold_trend_chart_widget.dart';
import '../../../data/gold_chart_point.dart';
import '../../../repository/gold_history_repository.dart';
import '../../../services/gold_trend/gold_aggregation_service.dart';

class GoldTrendChartScreenContent extends StatefulWidget {
  const GoldTrendChartScreenContent({super.key});

  @override
  State<GoldTrendChartScreenContent> createState() =>
      _GoldTrendChartScreenContentState();
}

class _GoldTrendChartScreenContentState
    extends State<GoldTrendChartScreenContent> {
  List<GoldChartPoint> historyPoints = [];
  List<GoldChartPoint> forecastPoints = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final snapshots = await GoldHistoryRepository().readSnapshots();

    final goldAggregationService = GoldAggregationService();

    final goldTimeline =
        goldAggregationService.buildTotalGoldTimeline(snapshots);

    final dailyGoldTimeline =
        goldAggregationService.compressTimelineToDailyLastValue(goldTimeline);

    if (!mounted) {
      return;
    }

    setState(() {
      historyPoints =
          goldAggregationService.buildChartPoints(dailyGoldTimeline);

      forecastPoints =
          goldAggregationService.buildForecastPoints(historyPoints);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
      child: GoldTrendChartWidget(
        historyPoints: historyPoints,
        forecastPoints: forecastPoints,
      ),
    );
  }
}
