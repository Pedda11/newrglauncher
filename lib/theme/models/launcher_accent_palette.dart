import 'package:flutter/material.dart';

@immutable
class LauncherAccentPalette {
  final Color accent;
  final Color accentStrong;
  final Color accentSoft;
  final Color accentGlow;
  final Color accentBackground;

  const LauncherAccentPalette({
    required this.accent,
    required this.accentStrong,
    required this.accentSoft,
    required this.accentGlow,
    required this.accentBackground,
  });
}
