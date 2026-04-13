import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../localization/generated/l10n.dart';
import '../cubit/settings_screen_cubit.dart';

class FindWowExeWidget extends StatelessWidget {
  const FindWowExeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<SettingsScreenCubit>();
    final locales = Localize.of(context);
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            screenCubit.findWowExeAndEmitProgress();
          },
          child: Text(locales.settingsScreenWowPathScanBtn),
        ),
        const SizedBox(width: 8),
        Text(locales.settingsScreenWowPathScanBtnHint),
      ],
    );
  }
}
