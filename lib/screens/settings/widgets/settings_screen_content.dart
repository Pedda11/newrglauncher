import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:win32/win32.dart';
import '../../../localization/generated/l10n.dart';
import '../../../repository/settings_repository.dart';
import '../cubit/settings_screen_cubit.dart';

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
    return Expanded(
      child: BlocConsumer<SettingsScreenCubit, SettingsScreenState>(
        builder: (context, state) {
          _wowPathController.text =
              '${settingsRepository.wowRootFolderPath ?? ''}${settingsRepository.wowExecutableName ?? ''}';
          return state.maybeWhen(
            initial: () {
              screenCubit.initialize();
              return const CircularProgressIndicator();
            },
            initialized: () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locales.settingsScreenSetWowPath,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        screenCubit.findWowExeAndEmitProgress();
                      },
                      child: const Text('Scan your system for wow.exe'),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                        '<- Scan your drives for wow.exe and select it from the shown list.'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Row(
                      children: settingsRepository.drives.map((drive) {
                        return ElevatedButton(
                          onPressed: () async {
                            try {
                              final dir = Directory(drive);

                              final exists = await dir.exists();

                              if (!exists) {
                                throw FileSystemException(
                                    "Drive not available", drive);
                              }

                              String? path = await FilesystemPicker.openDialog(
                                folderIconColor: const Color(0xFFE0CDA1),
                                title: 'Select File',
                                context: context,
                                rootDirectory: dir,
                                fsType: FilesystemType.file,
                                allowedExtensions: ['.exe'],
                                pickText: 'Select',
                                fileTileSelectMode:
                                    FileTileSelectMode.wholeTile,
                              );

                              if (path != null) {
                                screenCubit.changeWowFilePath(path);
                              }
                            } catch (e) {
                              if (!context.mounted) return;

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Drive not accessible'),
                                  content: Text(
                                      'Could not access drive $drive\n\n$e'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text(drive),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                        '<- Or select from one of the available drives.'),
                  ],
                ),
                const SizedBox(height: 24),
                Text(locales.settingsScreenWowPathLabel),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _wowPathController.text,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 24),
                Text(locales.settingsScreenTimeTillGameStartLabel),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: settingsRepository.secondsToWaitForGameToStart
                                ?.toDouble() ??
                            3,
                        min: 3,
                        max: 60,
                        divisions: 57,
                        label: settingsRepository.secondsToWaitForGameToStart
                            .toString(),
                        onChanged: (double value) {
                          screenCubit
                              .changeSecondsToWaitForGameToStart(value.toInt());
                        },
                      ),
                    ),
                    Text(
                      '${settingsRepository.secondsToWaitForGameToStart} ${locales.settingsScreenTimeTillGameStartType}',
                    ),
                  ],
                ),
              ],
            ),
            searchProgress: (searchedFolders, searchedFiles, foundExecutables) {
              return Column(
                children: [
                  Text('Scanned Folder: $searchedFolders'),
                  Text('Scanned Files: $searchedFiles'),
                  Text('Found Executables: $foundExecutables'),
                ],
              );
            },
            foundWowExe: (wowFiles) {
              return Column(
                children: wowFiles
                    .map((file) => ListTile(
                          title: Text(file.path),
                          onTap: () {
                            screenCubit.changeWowFilePath(file.path);
                          },
                        ))
                    .toList(),
              );
            },
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
                    title: Text(locales.settingsScreenWowDataPathLabel),
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
      ),
    );
  }

  @override
  void dispose() {
    _wowPathController.dispose();
    super.dispose();
  }
}
