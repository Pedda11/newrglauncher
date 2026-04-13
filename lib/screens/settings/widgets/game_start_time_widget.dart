import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../localization/generated/l10n.dart';
import '../../../repository/settings_repository.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Slider(
            value:
                settingsRepository.secondsToWaitForGameToStart?.toDouble() ?? 3,
            min: 3,
            max: 60,
            divisions: 57,
            label: settingsRepository.secondsToWaitForGameToStart.toString(),
            onChanged: (double value) {
              setState(() {
                screenCubit.changeSecondsToWaitForGameToStart(value.toInt());
              });
            },
          ),
        ),
        Text(
          '${settingsRepository.secondsToWaitForGameToStart ?? ''} ${locales.settingsScreenTimeTillGameStartType}',
        ),
      ],
    );
  }
}
