import 'package:flutter/material.dart';
import '../theme/helpers/theme_context_extensions.dart';

class LauncherCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const LauncherCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final radius = context.launcherRadius;

    final borderRadius = BorderRadius.circular(radius.small);

    return MouseRegion(
      cursor: onChanged != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onChanged != null ? () => onChanged!(!value) : null,
          borderRadius: borderRadius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: value
                  ? colors.accent.withValues(alpha: 0.95)
                  : colors.inputBackground.withValues(alpha: 0.92),
              border: Border.all(
                color: value
                    ? colors.accentStrong.withValues(alpha: 0.95)
                    : colors.accent.withValues(alpha: 0.24),
                width: 1.2,
              ),
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: colors.accent.withValues(alpha: 0.28),
                        blurRadius: 14,
                        spreadRadius: 0,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.16),
                        blurRadius: 8,
                        spreadRadius: -2,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 120),
              opacity: value ? 1 : 0,
              child: const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
