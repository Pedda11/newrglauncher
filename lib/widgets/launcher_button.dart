import 'package:flutter/material.dart';
import '../theme/extensions/launcher_color_tokens.dart';
import '../theme/extensions/launcher_spacing_tokens.dart';
import '../theme/helpers/theme_context_extensions.dart';

class LauncherButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  const LauncherButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = true,
  });

  @override
  State<LauncherButton> createState() => _LauncherButtonState();
}

class _LauncherButtonState extends State<LauncherButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final radius = context.launcherRadius;
    final spacing = context.launcherSpacing;

    final buttonRadius = BorderRadius.circular(radius.button);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: widget.primary
          ? _buildPrimaryButton(
              colors: colors,
              spacing: spacing,
              buttonRadius: buttonRadius,
            )
          : _buildSecondaryButton(
              colors: colors,
              spacing: spacing,
              buttonRadius: buttonRadius,
            ),
    );
  }

  Widget _buildSecondaryButton({
    required dynamic colors,
    required dynamic spacing,
    required BorderRadius buttonRadius,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: buttonRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: buttonRadius,
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ),
          decoration: BoxDecoration(
            color: _pressed
                ? colors.buttonSecondaryBackground.withValues(alpha: 0.75)
                : _hovered
                    ? colors.buttonSecondaryBackground.withValues(alpha: 0.9)
                    : colors.buttonSecondaryBackground,
            borderRadius: buttonRadius,
            border: Border.all(
              color: colors.panelBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 14,
                spreadRadius: -4,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.buttonSecondaryForeground,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required LauncherColorTokens colors,
    required LauncherSpacingTokens spacing,
    required BorderRadius buttonRadius,
  }) {
    final List<Color> gradientColors = _hovered
        ? [
            colors.accentSoft.withValues(alpha: 0.95),
            colors.accent.withValues(alpha: 1.0),
            colors.accentStrong.withValues(alpha: 1.0),
          ]
        : [
            colors.accentSoft.withValues(alpha: 0.92),
            colors.accent.withValues(alpha: 0.98),
            colors.accentStrong.withValues(alpha: 1.0),
          ];

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: buttonRadius,
        boxShadow: [
          BoxShadow(
            color: colors.accent.withValues(alpha: _hovered ? 0.42 : 0.32),
            blurRadius: _hovered ? 24 : 18,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 14,
            spreadRadius: -4,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: buttonRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: buttonRadius,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: buttonRadius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                /// top-left light hotspot
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(-0.85, -0.85),
                          radius: 1.0,
                          colors: [
                            Colors.white.withValues(alpha: 0.24),
                            Colors.white.withValues(alpha: 0.08),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.18, 0.55],
                        ),
                      ),
                    ),
                  ),
                ),

                /// bottom edge light
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.10),
                            Colors.white.withValues(alpha: 0.16),
                            Colors.white.withValues(alpha: 0.10),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                /// label defines button size
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.lg,
                    vertical: spacing.md,
                  ),
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.buttonPrimaryForeground,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
