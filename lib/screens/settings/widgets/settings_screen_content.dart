import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/screens/settings/widgets/find_wow_exe_widget.dart';
import 'package:twodotnulllauncher/screens/settings/widgets/launcher_pin_widget.dart';
import 'package:twodotnulllauncher/screens/settings/widgets/manuelly_find_wow_exe_widget.dart';
import 'package:twodotnulllauncher/screens/settings/widgets/search_wow_exe_progress_widget.dart';
import 'package:win32/win32.dart';
import '../../../localization/generated/l10n.dart';
import '../../../repository/settings_repository.dart';
import '../../../theme/helpers/theme_context_extensions.dart';
import '../../../widgets/launcher_panel.dart';
import '../cubit/settings_screen_cubit.dart';
import 'game_start_time_widget.dart';

class SettingsScreenContent extends StatefulWidget {
  const SettingsScreenContent({super.key});

  @override
  State<SettingsScreenContent> createState() => _SettingsScreenContentState();
}

class _SettingsScreenContentState extends State<SettingsScreenContent> {
  final _wowPathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<SettingsScreenCubit>();
    final settingsRepository = context.read<SettingsRepository>();
    final locales = Localize.of(context);
    final theme = Theme.of(context);
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final effects = context.launcherEffects;
    return BlocConsumer<SettingsScreenCubit, SettingsScreenState>(
      builder: (context, state) {
        _wowPathController.text =
            '${settingsRepository.wowRootFolderPath ?? ''}${settingsRepository.wowExecutableName ?? ''}';
        return state.maybeWhen(
          initial: () {
            return const CircularProgressIndicator();
          },
          scanningForDrives: () => Center(
            child: Column(
              children: [
                Text(locales.settingsScreenScanningForDrives),
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ),
          ),
          initialized: () => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                LauncherPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (settingsRepository.wowRootFolderPath == null) ...[
                        Text(
                          locales.settingsScreenWowPathMissingLabel,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: spacing.md),
                      ],
                      Text(
                        locales.settingsScreenSetWowPathLabel,
                        style: TextStyle(
                          color: colors.titleText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        locales.settingsScreenWowPathScanBtnHint,
                        style: TextStyle(
                          color: colors.mutedText,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: spacing.lg),
                      const FindWowExeWidget(),
                      SizedBox(height: spacing.md),
                      const ManuallyFindWowExeWidget(),
                      SizedBox(height: spacing.xl),
                      Text(
                        locales.settingsScreenWowPathLabel,
                        style: TextStyle(
                          color: colors.bodyText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: spacing.sm),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.lg,
                          vertical: spacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: colors.inputBackground,
                          borderRadius: BorderRadius.circular(radius.input),
                          border: Border.all(
                            color: colors.inputBorder,
                            width: effects.inputBorderWidth,
                          ),
                        ),
                        child: Text(
                          _wowPathController.text.isEmpty
                              ? '-'
                              : _wowPathController.text,
                          style: TextStyle(
                            color: colors.bodyText,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          searchProgress: (searchedFolders, searchedFiles, foundExecutables) {
            return SearchWowExeProgressWidget(
              searchedFolders: searchedFolders,
              searchedFiles: searchedFiles,
              foundExecutables: foundExecutables,
            );
          },
          foundWowExe: (wowFiles) => Column(
            children: [
              Text(
                locales.settingsScreenFoundWowExesLabel,
                style: const TextStyle(fontSize: 20),
              ),
              Column(
                children: wowFiles
                    .map((file) => ListTile(
                          title: Text(file.path),
                          onTap: () {
                            screenCubit.changeWowFilePath(file.path);
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
          orElse: () => const CircularProgressIndicator(),
        );
      },
      listener: (context, state) {
        state.whenOrNull(
          chooseDataFolder: (dataFolder) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    children: [
                      Text(locales.settingsScreenWowDataPathLabel),
                      Text(
                        locales.settingsScreenWowDataPathHint,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  content: Column(
                    children: dataFolder
                        .map((e) => ListTile(
                              title: Text(e),
                              onTap: () {
                                screenCubit.changeDataDirectory(e);
                                Navigator.of(context).pop();
                              },
                            ))
                        .toList(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _wowPathController.dispose();
    super.dispose();
  }
}
