import 'package:flutter/material.dart';

@immutable
class LauncherSpacingTokens extends ThemeExtension<LauncherSpacingTokens> {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  /// Layout specific
  final double screenPadding;
  final double panelPadding;
  final double sectionGap;

  const LauncherSpacingTokens({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.screenPadding,
    required this.panelPadding,
    required this.sectionGap,
  });

  @override
  LauncherSpacingTokens copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? screenPadding,
    double? panelPadding,
    double? sectionGap,
  }) {
    return LauncherSpacingTokens(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      screenPadding: screenPadding ?? this.screenPadding,
      panelPadding: panelPadding ?? this.panelPadding,
      sectionGap: sectionGap ?? this.sectionGap,
    );
  }

  @override
  LauncherSpacingTokens lerp(
      ThemeExtension<LauncherSpacingTokens>? other, double t) {
    if (other is! LauncherSpacingTokens) return this;

    double lerpDouble(double a, double b) => a + (b - a) * t;

    return LauncherSpacingTokens(
      xs: lerpDouble(xs, other.xs),
      sm: lerpDouble(sm, other.sm),
      md: lerpDouble(md, other.md),
      lg: lerpDouble(lg, other.lg),
      xl: lerpDouble(xl, other.xl),
      screenPadding: lerpDouble(screenPadding, other.screenPadding),
      panelPadding: lerpDouble(panelPadding, other.panelPadding),
      sectionGap: lerpDouble(sectionGap, other.sectionGap),
    );
  }
}
