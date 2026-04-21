import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/widgets/launcher_button.dart';

import '../../../localization/generated/l10n.dart';
import '../cubit/settings_screen_cubit.dart';

class SearchWowExeProgressWidget extends StatelessWidget {
  final int searchedFolders;
  final int searchedFiles;
  final List<File> foundExecutables;

  const SearchWowExeProgressWidget({
    super.key,
    required this.searchedFolders,
    required this.searchedFiles,
    required this.foundExecutables,
  });

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<SettingsScreenCubit>();
    final locales = Localize.of(context);

    return Center(
      child: Column(
        children: [
          LauncherButton(
            label: locales.settingsScreenCancelWowScanLabel,
            onPressed: () => screenCubit.cancelWowExeSearch(),
          ),
          Text('${locales.settingsScreenScannedFolders} $searchedFolders'),
          Text('${locales.settingsScreenScannedFiles} $searchedFiles'),
          const SizedBox(
            height: 32,
          ),
          foundExecutables.isNotEmpty
              ? Text(
                  locales.settingsScreenFoundWowExesLabel,
                  style: const TextStyle(fontSize: 20),
                )
              : Container(),
          Column(
            children: foundExecutables
                .map((file) => ListTile(
                      title: Text(file.path),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
