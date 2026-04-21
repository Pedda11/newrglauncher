import 'package:flutter/material.dart';
import '../models/launcher_accent_palette.dart';

class LauncherAccentBuilder {
  static LauncherAccentPalette fromHue(double hue) {
    final accentBase = HSVColor.fromAHSV(
      1,
      hue,
      0.88,
      0.98,
    );

    final accentStrongBase = HSVColor.fromAHSV(
      1,
      hue,
      0.98,
      1.0,
    );

    final accentSoftBase = HSVColor.fromAHSV(
      1,
      hue,
      0.72,
      0.88,
    );

    final accent = accentBase.toColor();
    final accentStrong = accentStrongBase.toColor();
    final accentSoft = accentSoftBase.toColor();

    final accentGlow = accentStrong.withValues(alpha: 0.35);
    final accentBackground = accent.withValues(alpha: 0.14);

    return LauncherAccentPalette(
      accent: accent,
      accentStrong: accentStrong,
      accentSoft: accentSoft,
      accentGlow: accentGlow,
      accentBackground: accentBackground,
    );
  }
}
