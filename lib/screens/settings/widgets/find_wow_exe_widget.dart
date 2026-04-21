import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../localization/generated/l10n.dart';
import '../../../theme/helpers/theme_context_extensions.dart';
import '../../../widgets/launcher_button.dart';
import '../cubit/settings_screen_cubit.dart';

class FindWowExeWidget extends StatelessWidget {
  const FindWowExeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<SettingsScreenCubit>();
    final locales = Localize.of(context);
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final text = context.launcherText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LauncherButton(
          label: locales.settingsScreenWowPathScanBtn,
          onPressed: () {
            screenCubit.findWowExeAndEmitProgress();
          },
        ),
        SizedBox(height: spacing.sm),
        Text(
          locales.settingsScreenWowPathScanBtnHint,
          style: text.hintText,
        ),
      ],
    );
  }
}
