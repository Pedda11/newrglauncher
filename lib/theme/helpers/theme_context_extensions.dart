import 'package:flutter/material.dart';
import '../extensions/launcher_color_tokens.dart';
import '../extensions/launcher_effect_tokens.dart';
import '../extensions/launcher_radius_tokens.dart';
import '../extensions/launcher_spacing_tokens.dart';
import '../extensions/launcher_text_tokens.dart';

extension ThemeContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  LauncherColorTokens get launcherColors =>
      theme.extension<LauncherColorTokens>()!;

  LauncherSpacingTokens get launcherSpacing =>
      theme.extension<LauncherSpacingTokens>()!;

  LauncherRadiusTokens get launcherRadius =>
      theme.extension<LauncherRadiusTokens>()!;

  LauncherEffectTokens get launcherEffects =>
      theme.extension<LauncherEffectTokens>()!;

  LauncherTextTokens get launcherText => theme.extension<LauncherTextTokens>()!;
}
