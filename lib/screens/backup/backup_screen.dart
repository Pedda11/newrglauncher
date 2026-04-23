import 'package:flutter/material.dart';
import '../../localization/generated/l10n.dart';
import '../../theme/helpers/theme_context_extensions.dart';
import '../../widgets/launcher_panel.dart';

class BackupScreen extends StatelessWidget {
  final int processedFiles;
  final int totalFiles;
  final double progress;

  const BackupScreen({
    super.key,
    required this.processedFiles,
    required this.totalFiles,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;

    final progressClamped = progress.clamp(0.0, 1.0);
    final progressPercent = (progressClamped * 100).toStringAsFixed(2);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: LauncherPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.backup_rounded,
                  size: 40,
                  color: colors.accentSoft,
                ),
                SizedBox(height: spacing.md),
                Text(
                  locales.backupScreenTitle,
                  style: text.sectionTitle.copyWith(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.sm),
                Text(
                  progressClamped <= 0.9
                      ? '$processedFiles / $totalFiles - $progressPercent%'
                      : locales.backupScreenFinalizingMessage,
                  style: text.sectionSubtitle.copyWith(
                    color: colors.mutedText,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.xl),
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius.button),
                    color: colors.inputBackground.withValues(alpha: 0.88),
                    border: Border.all(
                      color: colors.accent.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius.button),
                    child: Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: progressClamped,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  colors.accent.withValues(alpha: 0.85),
                                  colors.accentStrong.withValues(alpha: 0.95),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.accent.withValues(alpha: 0.24),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: spacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.accentSoft,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Text(
                      progressClamped < 1.0
                          ? locales.backupScreenTitle
                          : locales.backupScreenFinalizingMessage,
                      style: text.hintText.copyWith(
                        color: colors.bodyText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
