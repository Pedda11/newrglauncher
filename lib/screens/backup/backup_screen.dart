import 'package:flutter/material.dart';
import '../../localization/generated/l10n.dart';

class BackupScreen extends StatelessWidget {
  final int processedFiles;
  final int totalFiles;
  final double progress;

  const BackupScreen(
      {super.key,
      required this.processedFiles,
      required this.totalFiles,
      required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locales = Localize.of(context);
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              locales.backupScreenTitle,
              style: theme.textTheme.headlineLarge
                  ?.copyWith(color: theme.colorScheme.onPrimary),
            ),
            progress <= 0.9
                ? Text(
                    '$processedFiles/$totalFiles - ${(progress * 100).toStringAsFixed(2)}%',
                    style: theme.textTheme.headlineLarge
                        ?.copyWith(color: theme.colorScheme.onPrimary),
                  )
                : Text(
                    locales.backupScreenFinalizingMessage,
                    style: theme.textTheme.headlineLarge
                        ?.copyWith(color: theme.colorScheme.onPrimary),
                  ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
