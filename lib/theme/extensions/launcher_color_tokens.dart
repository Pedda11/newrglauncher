import 'package:flutter/material.dart';

@immutable
class LauncherColorTokens extends ThemeExtension<LauncherColorTokens> {
  /// Background layers
  final Color windowBackground;
  final Color sidebarBackground;
  final Color panelBackground;
  final Color panelBorder;

  /// Text
  final Color titleText;
  final Color bodyText;
  final Color mutedText;

  /// Inputs
  final Color inputBackground;
  final Color inputBorder;

  /// Accent-based (dynamic)
  final Color accent;
  final Color accentStrong;
  final Color accentSoft;
  final Color accentGlow;
  final Color accentBackground;

  /// Navigation
  final Color navActiveBackground;
  final Color navActiveIcon;
  final Color navInactiveIcon;

  /// Buttons
  final Color buttonPrimaryBackground;
  final Color buttonPrimaryForeground;
  final Color buttonSecondaryBackground;
  final Color buttonSecondaryForeground;

  /// Controls
  final Color sliderActive;
  final Color sliderInactive;
  final Color focusBorder;

  const LauncherColorTokens({
    required this.windowBackground,
    required this.sidebarBackground,
    required this.panelBackground,
    required this.panelBorder,
    required this.titleText,
    required this.bodyText,
    required this.mutedText,
    required this.inputBackground,
    required this.inputBorder,
    required this.accent,
    required this.accentStrong,
    required this.accentSoft,
    required this.accentGlow,
    required this.accentBackground,
    required this.navActiveBackground,
    required this.navActiveIcon,
    required this.navInactiveIcon,
    required this.buttonPrimaryBackground,
    required this.buttonPrimaryForeground,
    required this.buttonSecondaryBackground,
    required this.buttonSecondaryForeground,
    required this.sliderActive,
    required this.sliderInactive,
    required this.focusBorder,
  });

  @override
  LauncherColorTokens copyWith({
    Color? windowBackground,
    Color? sidebarBackground,
    Color? panelBackground,
    Color? panelBorder,
    Color? titleText,
    Color? bodyText,
    Color? mutedText,
    Color? inputBackground,
    Color? inputBorder,
    Color? accent,
    Color? accentStrong,
    Color? accentSoft,
    Color? accentGlow,
    Color? accentBackground,
    Color? navActiveBackground,
    Color? navActiveIcon,
    Color? navInactiveIcon,
    Color? buttonPrimaryBackground,
    Color? buttonPrimaryForeground,
    Color? buttonSecondaryBackground,
    Color? buttonSecondaryForeground,
    Color? sliderActive,
    Color? sliderInactive,
    Color? focusBorder,
  }) {
    return LauncherColorTokens(
      windowBackground: windowBackground ?? this.windowBackground,
      sidebarBackground: sidebarBackground ?? this.sidebarBackground,
      panelBackground: panelBackground ?? this.panelBackground,
      panelBorder: panelBorder ?? this.panelBorder,
      titleText: titleText ?? this.titleText,
      bodyText: bodyText ?? this.bodyText,
      mutedText: mutedText ?? this.mutedText,
      inputBackground: inputBackground ?? this.inputBackground,
      inputBorder: inputBorder ?? this.inputBorder,
      accent: accent ?? this.accent,
      accentStrong: accentStrong ?? this.accentStrong,
      accentSoft: accentSoft ?? this.accentSoft,
      accentGlow: accentGlow ?? this.accentGlow,
      accentBackground: accentBackground ?? this.accentBackground,
      navActiveBackground: navActiveBackground ?? this.navActiveBackground,
      navActiveIcon: navActiveIcon ?? this.navActiveIcon,
      navInactiveIcon: navInactiveIcon ?? this.navInactiveIcon,
      buttonPrimaryBackground:
          buttonPrimaryBackground ?? this.buttonPrimaryBackground,
      buttonPrimaryForeground:
          buttonPrimaryForeground ?? this.buttonPrimaryForeground,
      buttonSecondaryBackground:
          buttonSecondaryBackground ?? this.buttonSecondaryBackground,
      buttonSecondaryForeground:
          buttonSecondaryForeground ?? this.buttonSecondaryForeground,
      sliderActive: sliderActive ?? this.sliderActive,
      sliderInactive: sliderInactive ?? this.sliderInactive,
      focusBorder: focusBorder ?? this.focusBorder,
    );
  }

  @override
  LauncherColorTokens lerp(
      ThemeExtension<LauncherColorTokens>? other, double t) {
    if (other is! LauncherColorTokens) return this;

    return LauncherColorTokens(
      windowBackground:
          Color.lerp(windowBackground, other.windowBackground, t)!,
      sidebarBackground:
          Color.lerp(sidebarBackground, other.sidebarBackground, t)!,
      panelBackground: Color.lerp(panelBackground, other.panelBackground, t)!,
      panelBorder: Color.lerp(panelBorder, other.panelBorder, t)!,
      titleText: Color.lerp(titleText, other.titleText, t)!,
      bodyText: Color.lerp(bodyText, other.bodyText, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentStrong: Color.lerp(accentStrong, other.accentStrong, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      accentBackground:
          Color.lerp(accentBackground, other.accentBackground, t)!,
      navActiveBackground:
          Color.lerp(navActiveBackground, other.navActiveBackground, t)!,
      navActiveIcon: Color.lerp(navActiveIcon, other.navActiveIcon, t)!,
      navInactiveIcon: Color.lerp(navInactiveIcon, other.navInactiveIcon, t)!,
      buttonPrimaryBackground: Color.lerp(
          buttonPrimaryBackground, other.buttonPrimaryBackground, t)!,
      buttonPrimaryForeground: Color.lerp(
          buttonPrimaryForeground, other.buttonPrimaryForeground, t)!,
      buttonSecondaryBackground: Color.lerp(
          buttonSecondaryBackground, other.buttonSecondaryBackground, t)!,
      buttonSecondaryForeground: Color.lerp(
          buttonSecondaryForeground, other.buttonSecondaryForeground, t)!,
      sliderActive: Color.lerp(sliderActive, other.sliderActive, t)!,
      sliderInactive: Color.lerp(sliderInactive, other.sliderInactive, t)!,
      focusBorder: Color.lerp(focusBorder, other.focusBorder, t)!,
    );
  }
}
