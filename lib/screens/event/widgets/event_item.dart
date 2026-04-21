import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/rg_event_data.dart';
import '../../../enum/e_event_ui_status.dart';
import '../../../theme/extensions/launcher_color_tokens.dart';
import '../../../theme/helpers/theme_context_extensions.dart';

class EventItem extends StatelessWidget {
  final RgEventData rgEventData;

  const EventItem({
    super.key,
    required this.rgEventData,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;

    final visual = _resolveVisuals(colors);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius.card),
          onTap: () async {
            if (rgEventData.detailsUrl.isNotEmpty) {
              if (await canLaunchUrl(Uri.parse(rgEventData.detailsUrl))) {
                await launchUrl(Uri.parse(rgEventData.detailsUrl));
              } else {
                throw 'Could not launch ${Uri.parse(rgEventData.detailsUrl)}';
              }
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius.card),
              color: visual.backgroundColor,
              border: Border.all(
                color: visual.borderColor,
                width: visual.borderWidth,
              ),
              boxShadow: visual.shadows,
              gradient: visual.gradient,
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: visual.iconBorderColor,
                      width: 1,
                    ),
                    color: colors.inputBackground.withValues(alpha: 0.75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 10,
                        spreadRadius: -4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.network(
                          rgEventData.iconUrl,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.event,
                            color: colors.mutedText,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing.md),

                /// Name block
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rgEventData.name,
                        style: text.fieldValue.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: visual.titleColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        rgEventData.categoryName,
                        style: text.hintText.copyWith(
                          color: visual.subtitleColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: spacing.lg),

                /// Fixed date column
                SizedBox(
                  width: 400,
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: visual.metaColor,
                      ),
                      SizedBox(width: spacing.sm),
                      Expanded(
                        child: Text(
                          rgEventData.formattedDateRange,
                          style: text.fieldValue.copyWith(
                            color: visual.metaColor,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: spacing.lg),

                /// Fixed chip column
                SizedBox(
                  width: 130,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _EventStatusChip(
                      label: _statusLabel(),
                      color: visual.chipColor,
                      textColor: visual.chipTextColor,
                      backgroundColor: visual.chipBackgroundColor,
                      isFilled: visual.isChipFilled,
                    ),
                  ),
                ),

                SizedBox(width: spacing.md),

                Icon(
                  Icons.chevron_right_rounded,
                  color: visual.metaColor,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusLabel() {
    switch (rgEventData.uiStatus) {
      case EEventUiStatus.active:
        return 'AKTIV';
      case EEventUiStatus.upcoming:
        return 'KOMMEND';
      case EEventUiStatus.none:
        return 'SPÄTER';
    }
  }

  _EventItemVisuals _resolveVisuals(LauncherColorTokens colors) {
    switch (rgEventData.uiStatus) {
      case EEventUiStatus.active:
        return _EventItemVisuals(
          backgroundColor: colors.accent.withValues(alpha: 0.22),
          borderColor: colors.accentStrong.withValues(alpha: 0.95),
          borderWidth: 1.2,
          titleColor: Colors.white,
          subtitleColor: Colors.white.withValues(alpha: 0.72),
          metaColor: Colors.white.withValues(alpha: 0.90),
          iconBorderColor: colors.accentStrong.withValues(alpha: 0.90),
          chipColor: Colors.white,
          chipTextColor: Colors.white,
          chipBackgroundColor: colors.accentStrong.withValues(alpha: 0.28),
          isChipFilled: true,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.accent.withValues(alpha: 0.30),
              colors.accent.withValues(alpha: 0.16),
              colors.panelBackground.withValues(alpha: 0.92),
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
          shadows: [
            BoxShadow(
              color: colors.accent.withValues(alpha: 0.26),
              blurRadius: 18,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 16,
              spreadRadius: -6,
              offset: const Offset(0, 8),
            ),
          ],
        );

      case EEventUiStatus.upcoming:
        return _EventItemVisuals(
          backgroundColor: colors.panelBackground.withValues(alpha: 0.94),
          borderColor: colors.accent.withValues(alpha: 0.45),
          borderWidth: 1.0,
          titleColor: colors.bodyText,
          subtitleColor: colors.mutedText,
          metaColor: colors.bodyText.withValues(alpha: 0.78),
          iconBorderColor: colors.accent.withValues(alpha: 0.55),
          chipColor: colors.accent.withValues(alpha: 0.85),
          chipTextColor: colors.accent.withValues(alpha: 0.85),
          chipBackgroundColor: colors.accent.withValues(alpha: 0.10),
          isChipFilled: false,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.panelBackground.withValues(alpha: 1.0),
              colors.accent.withValues(alpha: 0.03),
            ],
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 14,
              spreadRadius: -6,
              offset: const Offset(0, 6),
            ),
          ],
        );

      case EEventUiStatus.none:
        return _EventItemVisuals(
          backgroundColor: colors.panelBackground.withValues(alpha: 0.84),
          borderColor: colors.panelBorder.withValues(alpha: 0.55),
          borderWidth: 1.0,
          titleColor: colors.bodyText.withValues(alpha: 0.72),
          subtitleColor: colors.mutedText.withValues(alpha: 0.70),
          metaColor: colors.mutedText.withValues(alpha: 0.70),
          iconBorderColor: colors.panelBorder.withValues(alpha: 0.55),
          chipColor: colors.mutedText.withValues(alpha: 0.75),
          chipTextColor: colors.mutedText.withValues(alpha: 0.75),
          chipBackgroundColor: colors.inputBackground.withValues(alpha: 0.72),
          isChipFilled: false,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.panelBackground.withValues(alpha: 0.92),
              colors.panelBackground.withValues(alpha: 0.86),
            ],
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 10,
              spreadRadius: -6,
              offset: const Offset(0, 5),
            ),
          ],
        );
    }
  }
}

class _EventStatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Color backgroundColor;
  final bool isFilled;

  const _EventStatusChip({
    required this.label,
    required this.color,
    required this.textColor,
    required this.backgroundColor,
    required this.isFilled,
  });

  @override
  Widget build(BuildContext context) {
    final radius = context.launcherRadius;
    final text = context.launcherText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.button),
        color: backgroundColor,
        border: Border.all(
          color: isFilled ? backgroundColor : color.withValues(alpha: 0.28),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isFilled
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.38),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: text.buttonSecondary.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventItemVisuals {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color titleColor;
  final Color subtitleColor;
  final Color metaColor;
  final Color iconBorderColor;
  final Color chipColor;
  final Color chipTextColor;
  final Color chipBackgroundColor;
  final bool isChipFilled;
  final Gradient gradient;
  final List<BoxShadow> shadows;

  const _EventItemVisuals({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.titleColor,
    required this.subtitleColor,
    required this.metaColor,
    required this.iconBorderColor,
    required this.chipColor,
    required this.chipTextColor,
    required this.chipBackgroundColor,
    required this.isChipFilled,
    required this.gradient,
    required this.shadows,
  });
}
