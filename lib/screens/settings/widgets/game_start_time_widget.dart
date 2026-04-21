import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../localization/generated/l10n.dart';
import '../../../repository/settings_repository.dart';
import '../../../theme/helpers/theme_context_extensions.dart';
import '../cubit/settings_screen_cubit.dart';

class GameStartTimeWidget extends StatefulWidget {
  const GameStartTimeWidget({super.key});

  @override
  State<GameStartTimeWidget> createState() => _GameStartTimeWidgetState();
}

class _GameStartTimeWidgetState extends State<GameStartTimeWidget> {
  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<SettingsScreenCubit>();
    final settingsRepository = context.read<SettingsRepository>();
    final locales = Localize.of(context);
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;

    final seconds =
        settingsRepository.secondsToWaitForGameToStart?.toDouble() ?? 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${seconds.toInt()}',
              style: TextStyle(
                color: colors.titleText,
                fontSize: 34,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
            SizedBox(width: spacing.xs),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                locales.settingsScreenTimeTillGameStartType,
                style: TextStyle(
                  color: colors.mutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.lg),
        Row(
          children: [
            Text(
              'Fast',
              style: TextStyle(
                color: colors.mutedText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  activeTrackColor: colors.accentStrong,
                  overlayColor: colors.accent.withValues(alpha: 0.22),
                  thumbShape: _NeonThumbShape(colors.accentStrong),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 22,
                  ),
                  tickMarkShape: const RoundSliderTickMarkShape(
                    tickMarkRadius: 1.2,
                  ),
                  activeTickMarkColor: Colors.white.withValues(alpha: 0.35),
                  inactiveTickMarkColor: Colors.white.withValues(alpha: 0.16),
                ),
                child: Slider(
                  value: seconds,
                  min: 3,
                  max: 60,
                  divisions: 57,
                  label: seconds.toInt().toString(),
                  onChanged: (double value) {
                    setState(() {
                      screenCubit.changeSecondsToWaitForGameToStart(
                        value.toInt(),
                      );
                    });
                  },
                ),
              ),
            ),
            SizedBox(width: spacing.md),
            Text(
              'Safe',
              style: TextStyle(
                color: colors.mutedText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NeonThumbShape extends SliderComponentShape {
  final Color color;

  const _NeonThumbShape(this.color);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    /// Outer glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawCircle(center, 12, glowPaint);

    /// Core
    final corePaint = Paint()..color = Colors.white;

    canvas.drawCircle(center, 8, corePaint);

    /// Inner highlight
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.6);

    canvas.drawCircle(
      center.translate(-2, -2),
      3,
      highlightPaint,
    );
  }
}
