import 'package:flutter/material.dart';

@immutable
class LauncherComponentTokens extends ThemeExtension<LauncherComponentTokens> {
  final double panelOuterPadding;

  final double primaryButtonHorizontalPadding;
  final double primaryButtonVerticalPadding;

  final double secondaryButtonHorizontalPadding;
  final double secondaryButtonVerticalPadding;

  final double inputContentHorizontalPadding;
  final double inputContentVerticalPadding;

  final double pinFieldWidth;

  const LauncherComponentTokens({
    required this.panelOuterPadding,
    required this.primaryButtonHorizontalPadding,
    required this.primaryButtonVerticalPadding,
    required this.secondaryButtonHorizontalPadding,
    required this.secondaryButtonVerticalPadding,
    required this.inputContentHorizontalPadding,
    required this.inputContentVerticalPadding,
    required this.pinFieldWidth,
  });

  @override
  LauncherComponentTokens copyWith({
    double? panelOuterPadding,
    double? primaryButtonHorizontalPadding,
    double? primaryButtonVerticalPadding,
    double? secondaryButtonHorizontalPadding,
    double? secondaryButtonVerticalPadding,
    double? inputContentHorizontalPadding,
    double? inputContentVerticalPadding,
    double? pinFieldWidth,
  }) {
    return LauncherComponentTokens(
      panelOuterPadding: panelOuterPadding ?? this.panelOuterPadding,
      primaryButtonHorizontalPadding:
          primaryButtonHorizontalPadding ?? this.primaryButtonHorizontalPadding,
      primaryButtonVerticalPadding:
          primaryButtonVerticalPadding ?? this.primaryButtonVerticalPadding,
      secondaryButtonHorizontalPadding: secondaryButtonHorizontalPadding ??
          this.secondaryButtonHorizontalPadding,
      secondaryButtonVerticalPadding:
          secondaryButtonVerticalPadding ?? this.secondaryButtonVerticalPadding,
      inputContentHorizontalPadding:
          inputContentHorizontalPadding ?? this.inputContentHorizontalPadding,
      inputContentVerticalPadding:
          inputContentVerticalPadding ?? this.inputContentVerticalPadding,
      pinFieldWidth: pinFieldWidth ?? this.pinFieldWidth,
    );
  }

  @override
  LauncherComponentTokens lerp(
    ThemeExtension<LauncherComponentTokens>? other,
    double t,
  ) {
    if (other is! LauncherComponentTokens) return this;

    double lerpDouble(double a, double b) => a + (b - a) * t;

    return LauncherComponentTokens(
      panelOuterPadding: lerpDouble(panelOuterPadding, other.panelOuterPadding),
      primaryButtonHorizontalPadding: lerpDouble(
        primaryButtonHorizontalPadding,
        other.primaryButtonHorizontalPadding,
      ),
      primaryButtonVerticalPadding: lerpDouble(
        primaryButtonVerticalPadding,
        other.primaryButtonVerticalPadding,
      ),
      secondaryButtonHorizontalPadding: lerpDouble(
        secondaryButtonHorizontalPadding,
        other.secondaryButtonHorizontalPadding,
      ),
      secondaryButtonVerticalPadding: lerpDouble(
        secondaryButtonVerticalPadding,
        other.secondaryButtonVerticalPadding,
      ),
      inputContentHorizontalPadding: lerpDouble(
        inputContentHorizontalPadding,
        other.inputContentHorizontalPadding,
      ),
      inputContentVerticalPadding: lerpDouble(
        inputContentVerticalPadding,
        other.inputContentVerticalPadding,
      ),
      pinFieldWidth: lerpDouble(pinFieldWidth, other.pinFieldWidth),
    );
  }
}
