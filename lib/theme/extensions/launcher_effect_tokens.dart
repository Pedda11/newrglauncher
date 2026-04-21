import 'package:flutter/material.dart';

@immutable
class LauncherEffectTokens extends ThemeExtension<LauncherEffectTokens> {
  final double panelBorderWidth;
  final double inputBorderWidth;
  final double focusBorderWidth;

  final double panelShadowBlur;
  final double panelShadowSpread;
  final double panelShadowOpacity;

  final double panelGlowBlur;
  final double panelGlowSpread;
  final double panelGlowOpacity;

  final double buttonGlowBlur;
  final double buttonGlowSpread;
  final double buttonGlowOpacity;

  const LauncherEffectTokens({
    required this.panelBorderWidth,
    required this.inputBorderWidth,
    required this.focusBorderWidth,
    required this.panelShadowBlur,
    required this.panelShadowSpread,
    required this.panelShadowOpacity,
    required this.panelGlowBlur,
    required this.panelGlowSpread,
    required this.panelGlowOpacity,
    required this.buttonGlowBlur,
    required this.buttonGlowSpread,
    required this.buttonGlowOpacity,
  });

  @override
  LauncherEffectTokens copyWith({
    double? panelBorderWidth,
    double? inputBorderWidth,
    double? focusBorderWidth,
    double? panelShadowBlur,
    double? panelShadowSpread,
    double? panelShadowOpacity,
    double? panelGlowBlur,
    double? panelGlowSpread,
    double? panelGlowOpacity,
    double? buttonGlowBlur,
    double? buttonGlowSpread,
    double? buttonGlowOpacity,
  }) {
    return LauncherEffectTokens(
      panelBorderWidth: panelBorderWidth ?? this.panelBorderWidth,
      inputBorderWidth: inputBorderWidth ?? this.inputBorderWidth,
      focusBorderWidth: focusBorderWidth ?? this.focusBorderWidth,
      panelShadowBlur: panelShadowBlur ?? this.panelShadowBlur,
      panelShadowSpread: panelShadowSpread ?? this.panelShadowSpread,
      panelShadowOpacity: panelShadowOpacity ?? this.panelShadowOpacity,
      panelGlowBlur: panelGlowBlur ?? this.panelGlowBlur,
      panelGlowSpread: panelGlowSpread ?? this.panelGlowSpread,
      panelGlowOpacity: panelGlowOpacity ?? this.panelGlowOpacity,
      buttonGlowBlur: buttonGlowBlur ?? this.buttonGlowBlur,
      buttonGlowSpread: buttonGlowSpread ?? this.buttonGlowSpread,
      buttonGlowOpacity: buttonGlowOpacity ?? this.buttonGlowOpacity,
    );
  }

  @override
  LauncherEffectTokens lerp(
    ThemeExtension<LauncherEffectTokens>? other,
    double t,
  ) {
    if (other is! LauncherEffectTokens) return this;

    double lerpDouble(double a, double b) => a + (b - a) * t;

    return LauncherEffectTokens(
      panelBorderWidth: lerpDouble(panelBorderWidth, other.panelBorderWidth),
      inputBorderWidth: lerpDouble(inputBorderWidth, other.inputBorderWidth),
      focusBorderWidth: lerpDouble(focusBorderWidth, other.focusBorderWidth),
      panelShadowBlur: lerpDouble(panelShadowBlur, other.panelShadowBlur),
      panelShadowSpread: lerpDouble(panelShadowSpread, other.panelShadowSpread),
      panelShadowOpacity: lerpDouble(
        panelShadowOpacity,
        other.panelShadowOpacity,
      ),
      panelGlowBlur: lerpDouble(panelGlowBlur, other.panelGlowBlur),
      panelGlowSpread: lerpDouble(panelGlowSpread, other.panelGlowSpread),
      panelGlowOpacity: lerpDouble(panelGlowOpacity, other.panelGlowOpacity),
      buttonGlowBlur: lerpDouble(buttonGlowBlur, other.buttonGlowBlur),
      buttonGlowSpread: lerpDouble(buttonGlowSpread, other.buttonGlowSpread),
      buttonGlowOpacity: lerpDouble(buttonGlowOpacity, other.buttonGlowOpacity),
    );
  }
}
