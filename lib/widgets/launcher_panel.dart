import 'package:flutter/material.dart';
import '../theme/helpers/theme_context_extensions.dart';

class LauncherPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const LauncherPanel({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final radius = context.launcherRadius;
    final effects = context.launcherEffects;
    final spacing = context.launcherSpacing;

    return Container(
      padding: padding ?? EdgeInsets.all(spacing.panelPadding),
      decoration: BoxDecoration(
        color: colors.panelBackground,
        borderRadius: BorderRadius.circular(radius.panel),
        border: Border.all(
          color: colors.panelBorder,
          width: effects.panelBorderWidth,
        ),
        boxShadow: [
          /// Base shadow (depth)
          BoxShadow(
            color: Colors.black.withOpacity(effects.panelShadowOpacity),
            blurRadius: effects.panelShadowBlur,
            spreadRadius: effects.panelShadowSpread,
          ),

          /// Accent glow (the sexy part)
          BoxShadow(
            color: colors.accentGlow.withOpacity(effects.panelGlowOpacity),
            blurRadius: effects.panelGlowBlur,
            spreadRadius: effects.panelGlowSpread,
          ),
        ],
      ),
      child: child,
    );
  }
}
