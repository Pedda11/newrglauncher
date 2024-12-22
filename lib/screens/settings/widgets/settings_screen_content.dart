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
                    )),
                    IconButton(
                      onPressed: () async {
                        String? path = await FilesystemPicker.openDialog(
                          folderIconColor: Color(0xFFD2B48C),
                          showGoUp: true,
                          title: 'Open file',
                          context: context,
                          directory: Directory.current,
                          rootDirectory: Directory.fromUri(Uri.file('C:/')),
                          fsType: FilesystemType.file,
                          allowedExtensions: ['.exe'],
                          fileTileSelectMode: FileTileSelectMode.wholeTile,
                        );
                        if (path != null) {
                          _wowPathController.text = path;
                          screenCubit.changeWowFilePath(path);
                        }
                      },
                      icon: Icon(Icons.file_download),
                    ),
                    IconButton(
                        onPressed: () => screenCubit.deleteDataDirectory(),
                        icon: Icon(Icons.delete))
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
                    title: Text('Choose data folder'),
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
}
