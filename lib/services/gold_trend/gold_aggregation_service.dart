import '../../data/gold_chart_point.dart';
import '../../data/gold_snapshot.dart';

class GoldAggregationService {
  int calculateCurrentTotalGoldCopper(List<GoldSnapshot> snapshots) {
    if (snapshots.isEmpty) {
      return 0;
    }

    final latestByCharacter = <String, GoldSnapshot>{};

    for (final snapshot in snapshots) {
      final existing = latestByCharacter[snapshot.characterKey];

      if (existing == null ||
          snapshot.lastLogoutTimestamp > existing.lastLogoutTimestamp) {
        latestByCharacter[snapshot.characterKey] = snapshot;
      }
    }

    var totalCopper = 0;

    for (final snapshot in latestByCharacter.values) {
      totalCopper += snapshot.goldCopper;
    }

    return totalCopper;
  }

  List<GoldSnapshot> buildTotalGoldTimeline(List<GoldSnapshot> snapshots) {
    if (snapshots.isEmpty) {
      return [];
    }

    // Sort by time ascending
    final sorted = [...snapshots]
      ..sort((a, b) => a.lastLogoutTimestamp.compareTo(b.lastLogoutTimestamp));

    final latestByCharacter = <String, int>{};
    final timeline = <GoldSnapshot>[];

    for (final snapshot in sorted) {
      // Update latest gold for this character
      latestByCharacter[snapshot.characterKey] = snapshot.goldCopper;

      // Sum current state
      final totalCopper =
          latestByCharacter.values.fold(0, (sum, val) => sum + val);

      // Create synthetic "total snapshot"
      timeline.add(
        GoldSnapshot(
          accountName: 'ALL',
          characterName: 'ALL',
          realm: snapshot.realm,
          goldCopper: totalCopper,
          lastLogoutTimestamp: snapshot.lastLogoutTimestamp,
        ),
      );
    }

    return timeline;
  }

  List<GoldSnapshot> compressTimelineToDailyLastValue(
    List<GoldSnapshot> timeline,
  ) {
    if (timeline.isEmpty) {
      return [];
    }

    final dailySnapshots = <String, GoldSnapshot>{};

    for (final snapshot in timeline) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        snapshot.lastLogoutTimestamp * 1000,
      );

      final dayKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final existing = dailySnapshots[dayKey];

      if (existing == null ||
          snapshot.lastLogoutTimestamp > existing.lastLogoutTimestamp) {
        dailySnapshots[dayKey] = snapshot;
      }
    }

    final result = dailySnapshots.values.toList()
      ..sort((a, b) => a.lastLogoutTimestamp.compareTo(b.lastLogoutTimestamp));

    return result;
  }

  List<GoldChartPoint> buildChartPoints(
    List<GoldSnapshot> dailySnapshots,
  ) {
    return dailySnapshots.map((snapshot) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        snapshot.lastLogoutTimestamp * 1000,
      );

      final gold = snapshot.goldCopper / 10000.0;

      return GoldChartPoint(
        date: date,
        gold: gold,
      );
    }).toList();
  }

  List<GoldChartPoint> buildForecastPoints(
    List<GoldChartPoint> points,
  ) {
    if (points.length < 2) {
      return [];
    }

    final sorted = [...points]..sort((a, b) => a.date.compareTo(b.date));

    final cutoffDate = sorted.last.date.subtract(const Duration(days: 30));
    final recent = sorted.where((p) => !p.date.isBefore(cutoffDate)).toList();

    if (recent.length < 2) {
      return [];
    }

    final startDate = recent.first.date;
    final lastHistoryDate = sorted.last.date;
    final maxObservedGold =
        recent.map((e) => e.gold).reduce((a, b) => a > b ? a : b);

    final xs = <double>[];
    final ys = <double>[];
    final ws = <double>[];

    for (final p in recent) {
      final x = p.date.difference(startDate).inHours / 24.0;
      final y = p.gold;

      final ageFromLast = lastHistoryDate.difference(p.date).inHours / 24.0;
      final weight = 1.0 + ((30.0 - ageFromLast).clamp(0.0, 30.0) / 30.0) * 2.0;

      xs.add(x);
      ys.add(y);
      ws.add(weight);
    }

    double sumW = 0;
    double sumWX = 0;
    double sumWY = 0;
    double sumWXY = 0;
    double sumWX2 = 0;

    for (var i = 0; i < xs.length; i++) {
      sumW += ws[i];
      sumWX += ws[i] * xs[i];
      sumWY += ws[i] * ys[i];
      sumWXY += ws[i] * xs[i] * ys[i];
      sumWX2 += ws[i] * xs[i] * xs[i];
    }

    final denominator = (sumW * sumWX2 - sumWX * sumWX);
    if (denominator == 0) {
      return [];
    }

    final slope = (sumW * sumWXY - sumWX * sumWY) / denominator;
    final intercept = (sumWY - slope * sumWX) / sumW;

    double predict(double x) {
      return slope * x + intercept;
    }

    /// Build deviation pattern from recent real data
    final deviations = <double>[];
    for (var i = 0; i < recent.length; i++) {
      final trendY = predict(xs[i]);
      deviations.add(ys[i] - trendY);
    }

    /// Use only the last few deviations as wave pattern
    final tail = deviations.length >= 7
        ? deviations.sublist(deviations.length - 7)
        : [...deviations];

    /// Average amplitude cap so it does not become silly
    final avgAbsDeviation = tail.isEmpty
        ? 0.0
        : tail.map((e) => e.abs()).reduce((a, b) => a + b) / tail.length;

    final maxWaveAmplitude = avgAbsDeviation.clamp(0.0, 8000.0);

    final forecast = <GoldChartPoint>[];

    for (int daysAhead = 1; daysAhead <= 90; daysAhead++) {
      final futureDate = lastHistoryDate.add(Duration(days: daysAhead));
      final x = futureDate.difference(startDate).inHours / 24.0;

      var predictedGold = predict(x);

      /// Reuse recent deviation pattern with damping
      if (tail.isNotEmpty && maxWaveAmplitude > 0) {
        final patternValue = tail[(daysAhead - 1) % tail.length];

        /// Damping: wave becomes weaker further in the future
        final damping = (1.0 - (daysAhead / 120.0)).clamp(0.25, 1.0);

        final normalizedWave =
            patternValue.clamp(-maxWaveAmplitude, maxWaveAmplitude);

        predictedGold += normalizedWave * damping;
      }

      if (predictedGold < 0) {
        predictedGold = 0;
      }

      final maxReasonableGold = maxObservedGold * 2.0;
      if (predictedGold > maxReasonableGold) {
        predictedGold = maxReasonableGold;
      }

      forecast.add(
        GoldChartPoint(
          date: futureDate,
          gold: predictedGold,
        ),
      );
    }

    return forecast;
  }
}
