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

    // Sort by date just in case
    final sorted = [...points]..sort((a, b) => a.date.compareTo(b.date));

    // Take last 30 days (or all if less)
    final cutoffDate = sorted.last.date.subtract(const Duration(days: 30));

    final recent = sorted.where((p) => p.date.isAfter(cutoffDate)).toList();

    if (recent.length < 2) {
      return [];
    }

    // Convert to numeric (days since first point)
    final startDate = recent.first.date;

    final xs = <double>[];
    final ys = <double>[];

    for (final p in recent) {
      final days = p.date.difference(startDate).inHours / 24.0;
      xs.add(days);
      ys.add(p.gold);
    }

    // Linear regression (simple least squares)
    final n = xs.length;

    final sumX = xs.reduce((a, b) => a + b);
    final sumY = ys.reduce((a, b) => a + b);
    final sumXY =
        List.generate(n, (i) => xs[i] * ys[i]).reduce((a, b) => a + b);
    final sumX2 = xs.map((x) => x * x).reduce((a, b) => a + b);

    final denominator = (n * sumX2 - sumX * sumX);

    if (denominator == 0) {
      return [];
    }

    final slope = (n * sumXY - sumX * sumY) / denominator;
    final intercept = (sumY - slope * sumX) / n;

    double predict(double daysFromStart) {
      return slope * daysFromStart + intercept;
    }

    final lastDate = sorted.last.date;

    final futureDays = [7.0, 30.0, 90.0];

    final forecast = futureDays.map((daysAhead) {
      final futureDate = lastDate.add(Duration(days: daysAhead.toInt()));

      final totalDaysFromStart =
          futureDate.difference(startDate).inHours / 24.0;

      final predictedGold = predict(totalDaysFromStart);

      return GoldChartPoint(
        date: futureDate,
        gold: predictedGold,
      );
    }).toList();

    return forecast;
  }
}
