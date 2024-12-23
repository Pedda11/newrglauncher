import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return SizedBox(
      width: 800,
      child: BlocConsumer<SettingsScreenCubit, SettingsScreenState>(
        builder: (context, state) {
          _wowPathController.text =
              '${settingsRepository.wowRootFolderPath ?? ''}${settingsRepository.wowExecutableName ?? ''}';
          return state.maybeWhen(
            initial: () {
              screenCubit.initialize();
              return CircularProgressIndicator();
            },
            initialized: () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locales.settingsScreenWowPathLabel),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _wowPathController.text,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: settingsRepository.drives.map((drive) {
                        return ElevatedButton(
                          onPressed: () async {
                            String? path = await FilesystemPicker.openDialog(
                              folderIconColor: Color(0xFFE0CDA1),
                              title: 'Select File',
                              context: context,
                              rootDirectory: Directory(drive),
                              fsType: FilesystemType.file,
                              allowedExtensions: ['.exe'],
                              pickText: 'Select',
                              fileTileSelectMode: FileTileSelectMode.wholeTile,
                            );
                            if (path != null) {
                              screenCubit.changeWowFilePath(path);
                            }
                          },
                          child: Text(drive),
                        );
                      }).toList(),
                    )
                  ],
                ),
                SizedBox(height: 24),
                Text(locales.settingsScreenTimeTillGameStartLabel),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: settingsRepository.secondsToWaitForGameToStart
                            .toDouble(),
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
            orElse: () => CircularProgressIndicator(),
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
