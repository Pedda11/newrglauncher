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
    final text = context.launcherText;
    final components = context.launcherComponents;

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
            clipBehavior: Clip.none,
            padding: EdgeInsets.fromLTRB(
              spacing.screenPadding,
              spacing.screenPadding,
              spacing.screenPadding,
              spacing.screenPadding + 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: text.sectionTitle,
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        locales.settingsScreenSetWowPathLabelHint,
                        style: text.sectionSubtitle,
                      ),
                      SizedBox(height: spacing.md),
                      const FindWowExeWidget(),
                      SizedBox(height: spacing.xl),
                      const ManuallyFindWowExeWidget(),
                      SizedBox(height: spacing.xl),
                      Text(
                        locales.settingsScreenWowPathLabel,
                        style: text.fieldLabel,
                      ),
                      SizedBox(height: spacing.sm),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: components.inputContentHorizontalPadding,
                          vertical: components.inputContentVerticalPadding,
                        ),
                        decoration: BoxDecoration(
                          color: colors.inputBackground,
                          borderRadius: BorderRadius.circular(radius.input),
                          border: Border.all(
                            color: colors.accent.withValues(alpha: 0.14),
                            width: effects.inputBorderWidth,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                              spreadRadius: -4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.folder_outlined,
                              size: 18,
                              color: colors.mutedText.withValues(alpha: 0.9),
                            ),
                            SizedBox(width: spacing.md),
                            Expanded(
                              child: Text(
                                _wowPathController.text.isEmpty
                                    ? '-'
                                    : _wowPathController.text,
                                style: text.fieldValue,
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
                SizedBox(height: spacing.sectionGap),
                LauncherPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (settingsRepository.secondsToWaitForGameToStart ==
                          null) ...[
                        Text(
                          locales.settingsScreenTimeTillGameStartMissingLabel,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: spacing.md),
                      ],
                      Text(
                        'Eingabeverzögerung',
                        style: text.sectionTitle,
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        locales.settingsScreenTimeTillGameStartLabel,
                        style: text.sectionSubtitle,
                      ),
                      SizedBox(height: spacing.lg),
                      const GameStartTimeWidget(),
                    ],
                  ),
                ),
                SizedBox(height: spacing.sectionGap),
                const LauncherPinWidget(),
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
