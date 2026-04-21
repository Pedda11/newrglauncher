import 'package:flutter/material.dart';

import '../../../theme/helpers/theme_context_extensions.dart';

class EventStatusLegend extends StatelessWidget {
  const EventStatusLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: spacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.panelBackground,
        /*border: Border.symmetric(
          horizontal: BorderSide(
              color: colors.accent.withValues(alpha: 0.14), width: 1),
        ),*/
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Status-System',
            style: text.fieldLabel.copyWith(
              color: colors.accentSoft,
              fontWeight: FontWeight.w700,
            ),
          ),
          _LegendItem(
            label: 'Aktiv',
            dotColor: colors.accentStrong,
            textColor: colors.bodyText,
          ),
          _LegendItem(
            label: 'Kommend',
            dotColor: colors.accent.withValues(alpha: 0.85),
            textColor: colors.bodyText,
          ),
          _LegendItem(
            label: 'Später',
            dotColor: colors.mutedText.withValues(alpha: 0.75),
            textColor: colors.bodyText,
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color dotColor;
  final Color textColor;

  const _LegendItem({
    required this.label,
    required this.dotColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.launcherSpacing;
    final text = context.launcherText;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: dotColor.withValues(alpha: 0.30),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
        SizedBox(width: spacing.sm),
        Text(
          label,
          style: text.hintText.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
