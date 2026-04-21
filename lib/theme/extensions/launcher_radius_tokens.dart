import 'package:flutter/material.dart';

@immutable
class LauncherRadiusTokens extends ThemeExtension<LauncherRadiusTokens> {
  final double small;
  final double medium;
  final double large;

  /// Specific use-cases
  final double panel;
  final double button;
  final double input;
  final double card;

  const LauncherRadiusTokens({
    required this.small,
    required this.medium,
    required this.large,
    required this.panel,
    required this.button,
    required this.input,
    required this.card,
  });

  @override
  LauncherRadiusTokens copyWith({
    double? small,
    double? medium,
    double? large,
    double? panel,
    double? button,
    double? input,
    double? card,
  }) {
    return LauncherRadiusTokens(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      panel: panel ?? this.panel,
      button: button ?? this.button,
      input: input ?? this.input,
      card: card ?? this.card,
    );
  }

  @override
  LauncherRadiusTokens lerp(
      ThemeExtension<LauncherRadiusTokens>? other, double t) {
    if (other is! LauncherRadiusTokens) return this;

    double lerpDouble(double a, double b) => a + (b - a) * t;

    return LauncherRadiusTokens(
      small: lerpDouble(small, other.small),
      medium: lerpDouble(medium, other.medium),
      large: lerpDouble(large, other.large),
      panel: lerpDouble(panel, other.panel),
      button: lerpDouble(button, other.button),
      input: lerpDouble(input, other.input),
      card: lerpDouble(card, other.card),
    );
  }
}
