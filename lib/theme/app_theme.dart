import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_design_tokens.dart';
import 'app_text_theme.dart';

class AppTheme {
  static const AppDesignTokens _designTokens = AppDesignTokens(
    screenPadding: 16,
    cardRadius: 20,
    buttonRadius: 14,
    inputRadius: 12,
    smallSpacing: 8,
    mediumSpacing: 16,
    largeSpacing: 24,
  );

  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      tertiary: AppColors.secondary,
      onTertiary: Colors.white,
      primaryContainer: AppColors.primary.withValues(alpha: 0.12),
      onPrimaryContainer: AppColors.primary,
      secondaryContainer: AppColors.secondary.withValues(alpha: 0.12),
      onSecondaryContainer: AppColors.secondary,
      tertiaryContainer: AppColors.secondary.withValues(alpha: 0.12),
      onTertiaryContainer: AppColors.secondary,
      surfaceContainerHighest: const Color(0xFFE7E0EC),
      onSurfaceVariant: AppColors.textSecondaryLight,
      outline: const Color(0xFFCAC4D0),
      outlineVariant: const Color(0xFFE7E0EC),
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: const Color(0xFF313033),
      onInverseSurface: const Color(0xFFF4EFF4),
      inversePrimary: const Color(0xFFD0BCFF),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: AppTextTheme.lightTextTheme,
      extensions: const [_designTokens],
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_designTokens.cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_designTokens.buttonRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_designTokens.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_designTokens.inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_designTokens.inputRadius),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      tertiary: AppColors.secondary,
      onTertiary: Colors.white,
      primaryContainer: AppColors.primary.withValues(alpha: 0.18),
      onPrimaryContainer: Colors.white,
      secondaryContainer: AppColors.secondary.withValues(alpha: 0.18),
      onSecondaryContainer: Colors.white,
      tertiaryContainer: AppColors.secondary.withValues(alpha: 0.18),
      onTertiaryContainer: Colors.white,
      surfaceContainerHighest: const Color(0xFF2B2930),
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: const Color(0xFF938F99),
      outlineVariant: const Color(0xFF49454F),
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: const Color(0xFFF4EFF4),
      onInverseSurface: const Color(0xFF1C1B1F),
      inversePrimary: AppColors.primary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: AppTextTheme.darkTextTheme,
      extensions: const [_designTokens],
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_designTokens.cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_designTokens.buttonRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF232228),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_designTokens.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_designTokens.inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_designTokens.inputRadius),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
