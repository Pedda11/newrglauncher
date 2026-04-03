class GoldChartAxisHelper {
  static double calculateNiceInterval(double minY, double maxY) {
    final range = (maxY - minY).abs();

    if (range <= 10) return 1;
    if (range <= 25) return 5;
    if (range <= 50) return 10;
    if (range <= 100) return 20;
    if (range <= 250) return 50;
    if (range <= 500) return 100;
    if (range <= 1000) return 200;
    if (range <= 2500) return 500;
    if (range <= 5000) return 1000;
    if (range <= 10000) return 2000;
    if (range <= 25000) return 5000;
    if (range <= 50000) return 10000;
    if (range <= 100000) return 20000;
    return 50000;
  }

  static double roundDownToInterval(double value, double interval) {
    return (value / interval).floor() * interval;
  }

  static double roundUpToInterval(double value, double interval) {
    return (value / interval).ceil() * interval;
  }

  static (double, double) expandToMinimumVisualRange(double minY, double maxY) {
    final range = (maxY - minY).abs();
    final center = (minY + maxY) / 2;

    double minimumRange;

    if (center >= 100000) {
      minimumRange = 50000;
    } else if (center >= 10000) {
      minimumRange = 5000;
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
