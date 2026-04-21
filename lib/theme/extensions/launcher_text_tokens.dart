import 'package:flutter/material.dart';

@immutable
class LauncherTextTokens extends ThemeExtension<LauncherTextTokens> {
  final TextStyle sectionTitle;
  final TextStyle sectionSubtitle;
  final TextStyle fieldLabel;
  final TextStyle fieldValue;
  final TextStyle hintText;
  final TextStyle buttonPrimary;
  final TextStyle buttonSecondary;
  final TextStyle largeValue;
  final TextStyle pinFieldText;
  final TextStyle pinFieldHint;
  final TextStyle statusError;
  final TextStyle statusSuccess;

  const LauncherTextTokens({
    required this.sectionTitle,
    required this.sectionSubtitle,
    required this.fieldLabel,
    required this.fieldValue,
    required this.hintText,
    required this.buttonPrimary,
    required this.buttonSecondary,
    required this.largeValue,
    required this.pinFieldText,
    required this.pinFieldHint,
    required this.statusError,
    required this.statusSuccess,
  });

  @override
  LauncherTextTokens copyWith({
    TextStyle? sectionTitle,
    TextStyle? sectionSubtitle,
    TextStyle? fieldLabel,
    TextStyle? fieldValue,
    TextStyle? hintText,
    TextStyle? buttonPrimary,
    TextStyle? buttonSecondary,
    TextStyle? largeValue,
    TextStyle? pinFieldText,
    TextStyle? pinFieldHint,
    TextStyle? statusError,
    TextStyle? statusSuccess,
  }) {
    return LauncherTextTokens(
      sectionTitle: sectionTitle ?? this.sectionTitle,
      sectionSubtitle: sectionSubtitle ?? this.sectionSubtitle,
      fieldLabel: fieldLabel ?? this.fieldLabel,
      fieldValue: fieldValue ?? this.fieldValue,
      hintText: hintText ?? this.hintText,
      buttonPrimary: buttonPrimary ?? this.buttonPrimary,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
      largeValue: largeValue ?? this.largeValue,
      pinFieldText: pinFieldText ?? this.pinFieldText,
      pinFieldHint: pinFieldHint ?? this.pinFieldHint,
      statusError: statusError ?? this.statusError,
      statusSuccess: statusSuccess ?? this.statusSuccess,
    );
  }

  @override
  LauncherTextTokens lerp(
    ThemeExtension<LauncherTextTokens>? other,
    double t,
  ) {
    if (other is! LauncherTextTokens) return this;

    return LauncherTextTokens(
      sectionTitle: TextStyle.lerp(sectionTitle, other.sectionTitle, t)!,
      sectionSubtitle:
          TextStyle.lerp(sectionSubtitle, other.sectionSubtitle, t)!,
      fieldLabel: TextStyle.lerp(fieldLabel, other.fieldLabel, t)!,
      fieldValue: TextStyle.lerp(fieldValue, other.fieldValue, t)!,
      hintText: TextStyle.lerp(hintText, other.hintText, t)!,
      buttonPrimary: TextStyle.lerp(buttonPrimary, other.buttonPrimary, t)!,
      buttonSecondary:
          TextStyle.lerp(buttonSecondary, other.buttonSecondary, t)!,
      largeValue: TextStyle.lerp(largeValue, other.largeValue, t)!,
      pinFieldText: TextStyle.lerp(pinFieldText, other.pinFieldText, t)!,
      pinFieldHint: TextStyle.lerp(pinFieldHint, other.pinFieldHint, t)!,
      statusError: TextStyle.lerp(statusError, other.statusError, t)!,
      statusSuccess: TextStyle.lerp(statusSuccess, other.statusSuccess, t)!,
    );
  }
}
