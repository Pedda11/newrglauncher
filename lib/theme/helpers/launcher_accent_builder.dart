import 'package:flutter/material.dart';
import '../models/launcher_accent_palette.dart';

class LauncherAccentBuilder {
  static LauncherAccentPalette fromHue(double hue) {
    /// Base accent
    final base = HSVColor.fromAHSV(
      1,
      hue,
      0.65,
      0.95,
    );

    /// Strong accent (buttons, highlights)
    final strong = base.withSaturation(0.85).withValue(1.0);

    /// Soft accent (background hints)
    final soft = base.withSaturation(0.4).withValue(0.85);

    final accent = base.toColor();
    final accentStrong = strong.toColor();
    final accentSoft = soft.toColor();

    /// Glow (important: opacity only here)
    final accentGlow = accent.withOpacity(0.35);

    /// Subtle background (nav active etc.)
    final accentBackground = accent.withOpacity(0.12);

    return LauncherAccentPalette(
      accent: accent,
      accentStrong: accentStrong,
      accentSoft: accentSoft,
      accentGlow: accentGlow,
      accentBackground: accentBackground,
    );
  }
}
