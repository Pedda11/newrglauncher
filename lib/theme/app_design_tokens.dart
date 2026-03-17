import 'package:flutter/material.dart';

@immutable
class AppDesignTokens extends ThemeExtension<AppDesignTokens> {
  final double screenPadding;
  final double cardRadius;
  final double buttonRadius;
  final double inputRadius;
  final double smallSpacing;
  final double mediumSpacing;
  final double largeSpacing;

  const AppDesignTokens({
    required this.screenPadding,
    required this.cardRadius,
    required this.buttonRadius,
    required this.inputRadius,
    required this.smallSpacing,
    required this.mediumSpacing,
    required this.largeSpacing,
  });

  @override
  AppDesignTokens copyWith({
    double? screenPadding,
    double? cardRadius,
    double? buttonRadius,
    double? inputRadius,
    double? smallSpacing,
    double? mediumSpacing,
    double? largeSpacing,
  }) {
    return AppDesignTokens(
      screenPadding: screenPadding ?? this.screenPadding,
      cardRadius: cardRadius ?? this.cardRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      inputRadius: inputRadius ?? this.inputRadius,
      smallSpacing: smallSpacing ?? this.smallSpacing,
      mediumSpacing: mediumSpacing ?? this.mediumSpacing,
      largeSpacing: largeSpacing ?? this.largeSpacing,
    );
  }

  @override
  AppDesignTokens lerp(ThemeExtension<AppDesignTokens>? other, double t) {
    if (other is! AppDesignTokens) return this;

    return AppDesignTokens(
      screenPadding: lerpDouble(screenPadding, other.screenPadding, t)!,
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
      buttonRadius: lerpDouble(buttonRadius, other.buttonRadius, t)!,
      inputRadius: lerpDouble(inputRadius, other.inputRadius, t)!,
      smallSpacing: lerpDouble(smallSpacing, other.smallSpacing, t)!,
      mediumSpacing: lerpDouble(mediumSpacing, other.mediumSpacing, t)!,
      largeSpacing: lerpDouble(largeSpacing, other.largeSpacing, t)!,
    );
  }
}

double? lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
