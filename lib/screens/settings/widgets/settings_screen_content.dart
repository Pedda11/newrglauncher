import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/repository/settings_repository.dart';
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
    return BlocConsumer<SettingsScreenCubit, SettingsScreenState>(
      builder: (context, state) {
        _wowPathController.text =
            '${settingsRepository.wowRootFolderPath ?? ''}${settingsRepository.wowExecutableName ?? ''}';
        return state.maybeWhen(
          initialized: () => Column(
            children: [
              Row(
                children: [
                  Text(_wowPathController.text),
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
    );
  }
}
