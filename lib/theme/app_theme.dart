import 'package:flutter/material.dart';

import 'extensions/launcher_color_tokens.dart';
import 'extensions/launcher_effect_tokens.dart';
import 'extensions/launcher_radius_tokens.dart';
import 'extensions/launcher_spacing_tokens.dart';
import 'extensions/launcher_text_tokens.dart';
import 'helpers/launcher_accent_builder.dart';

class AppTheme {
  static ThemeData build({
    required double hue,
  }) {
    final accentPalette = LauncherAccentBuilder.fromHue(hue);

    const colors = LauncherColorTokens(
      windowBackground: Color(0xFF0F1117),
      sidebarBackground: Color(0xFF12131A),
      panelBackground: Color(0xFF1A1C23),
      panelBorder: Color(0x14FFFFFF),
      titleText: Colors.white,
      bodyText: Color(0xB3FFFFFF),
      mutedText: Color(0x61FFFFFF),
      inputBackground: Color(0xFF20222A),
      inputBorder: Color(0x1FFFFFFF),
      accent: Color(0x00000000),
      accentStrong: Color(0x00000000),
      accentSoft: Color(0x00000000),
      accentGlow: Color(0x00000000),
      accentBackground: Color(0x00000000),
      navActiveBackground: Color(0x00000000),
      navActiveIcon: Color(0x00000000),
      navInactiveIcon: Color(0x61FFFFFF),
      buttonPrimaryBackground: Color(0x00000000),
      buttonPrimaryForeground: Colors.white,
      buttonSecondaryBackground: Color(0xFF262A33),
      buttonSecondaryForeground: Color(0xB3FFFFFF),
      sliderActive: Color(0x00000000),
      sliderInactive: Color(0x33FFFFFF),
      focusBorder: Color(0x00000000),
    );

    const spacing = LauncherSpacingTokens(
      xs: 4,
      sm: 8,
      md: 12,
      lg: 16,
      xl: 24,
      screenPadding: 24,
      panelPadding: 20,
      sectionGap: 24,
    );

    const radius = LauncherRadiusTokens(
      small: 10,
      medium: 16,
      large: 24,
      panel: 24,
      button: 16,
      input: 16,
    );

    const effects = LauncherEffectTokens(
      panelBorderWidth: 1,
      inputBorderWidth: 1,
      focusBorderWidth: 1.4,
      panelShadowBlur: 30,
      panelShadowSpread: -8,
      panelShadowOpacity: 0.22,
      panelGlowBlur: 26,
      panelGlowSpread: -6,
      panelGlowOpacity: 0.18,
      buttonGlowBlur: 18,
      buttonGlowSpread: 0,
      buttonGlowOpacity: 0.22,
    );

    final resolvedColors = colors.copyWith(
      accent: accentPalette.accent,
      accentStrong: accentPalette.accentStrong,
      accentSoft: accentPalette.accentSoft,
      accentGlow: accentPalette.accentGlow,
      accentBackground: accentPalette.accentBackground,
      navActiveBackground: accentPalette.accentBackground,
      navActiveIcon: accentPalette.accentStrong,
      buttonPrimaryBackground: accentPalette.accent,
      sliderActive: accentPalette.accentStrong,
      focusBorder: accentPalette.accent,
    );

    final text = LauncherTextTokens(
      sectionTitle: TextStyle(
        color: resolvedColors.titleText,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      sectionSubtitle: TextStyle(
        color: resolvedColors.mutedText,
        fontSize: 13,
        height: 1.4,
      ),
      fieldLabel: TextStyle(
        color: resolvedColors.mutedText,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      fieldValue: TextStyle(
        color: resolvedColors.bodyText,
        fontSize: 14,
        height: 1.2,
      ),
      hintText: TextStyle(
        color: resolvedColors.mutedText,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      buttonPrimary: TextStyle(
        color: resolvedColors.buttonPrimaryForeground,
        fontWeight: FontWeight.w800,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      buttonSecondary: TextStyle(
        color: resolvedColors.buttonSecondaryForeground,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      largeValue: TextStyle(
        color: resolvedColors.titleText,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.0,
      ),
      pinFieldText: TextStyle(
        color: resolvedColors.bodyText,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
      pinFieldHint: TextStyle(
        color: resolvedColors.mutedText,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      statusError: const TextStyle(
        color: Colors.red,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      statusSuccess: const TextStyle(
        color: Colors.green,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
    );

    final colorScheme = ColorScheme.dark(
      primary: resolvedColors.accent,
      secondary: resolvedColors.accentSoft,
      surface: resolvedColors.panelBackground,
      error: const Color(0xFFFF6B6B),
      onPrimary: resolvedColors.buttonPrimaryForeground,
      onSecondary: Colors.white,
      onSurface: resolvedColors.titleText,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: resolvedColors.windowBackground,
      extensions: [
        resolvedColors,
        spacing,
        radius,
        effects,
        text,
      ],
      cardTheme: CardThemeData(
        color: resolvedColors.panelBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.panel),
          side: BorderSide(
            color: resolvedColors.panelBorder,
            width: effects.panelBorderWidth,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: resolvedColors.buttonPrimaryBackground,
          foregroundColor: resolvedColors.buttonPrimaryForeground,
          minimumSize: const Size(0, 52),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.lg,
            vertical: spacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.button),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: resolvedColors.inputBackground,
        hintStyle: TextStyle(
          color: resolvedColors.mutedText,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.input),
          borderSide: BorderSide(
            color: resolvedColors.inputBorder,
            width: effects.inputBorderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.input),
          borderSide: BorderSide(
            color: resolvedColors.inputBorder,
            width: effects.inputBorderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.input),
          borderSide: BorderSide(
            color: resolvedColors.focusBorder,
            width: effects.focusBorderWidth,
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: spacing.xs,
        activeTrackColor: resolvedColors.sliderActive,
        inactiveTrackColor: resolvedColors.sliderInactive,
        thumbColor: resolvedColors.accentStrong,
        overlayColor: resolvedColors.accentGlow,
      ),
    );
  }
}
