import 'package:flutter/material.dart';

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
    required dynamic colors,
    required dynamic spacing,
    required BorderRadius buttonRadius,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: buttonRadius,
        boxShadow: [
          BoxShadow(
            color: colors.accent.withValues(
              alpha: _pressed
                  ? 0.25
                  : _hovered
                      ? 0.55
                      : 0.40,
            ),
            blurRadius: _pressed
                ? 18
                : _hovered
                    ? 32
                    : 26,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 16,
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
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          borderRadius: buttonRadius,
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            decoration: BoxDecoration(
              borderRadius: buttonRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _pressed
                    ? [
                        colors.accentSoft,
                        colors.accent,
                        colors.accent,
                      ]
                    : _hovered
                        ? [
                            colors.accent,
                            colors.accentStrong,
                            colors.accentStrong,
                          ]
                        : [
                            colors.accentSoft,
                            colors.accent,
                            colors.accentStrong,
                          ],
              ),
            ),
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.buttonPrimaryForeground,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
