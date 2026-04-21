import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../localization/generated/l10n.dart';
import '../../../repository/settings_repository.dart';
import '../../../theme/helpers/theme_context_extensions.dart';
import '../../../widgets/launcher_button.dart';
import '../cubit/settings_screen_cubit.dart';

class ManuallyFindWowExeWidget extends StatefulWidget {
  const ManuallyFindWowExeWidget({super.key});

  @override
  State<ManuallyFindWowExeWidget> createState() =>
      _ManuallyFindWowExeWidgetState();
}

class _ManuallyFindWowExeWidgetState extends State<ManuallyFindWowExeWidget> {
  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<SettingsScreenCubit>();
    final settingsRepository = context.read<SettingsRepository>();
    final locales = Localize.of(context);
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final text = context.launcherText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: settingsRepository.drives.map((drive) {
            return LauncherButton(
              label: drive,
              primary: false,
              onPressed: () async {
                try {
                  final dir = Directory(drive);
                  Directory dirPath = dir;

                  final exists = await dir.exists();

                  if (!exists) {
                    throw FileSystemException(
                      locales.settingsScreenSetWowPathManuallyDriveException,
                      drive,
                    );
                  }

                  if (dir.path == 'C:\\') {
                    dirPath = Directory('${dir.path}Users\\');
                  }

                  String? path = await FilesystemPicker.openDialog(
                    folderIconColor: const Color(0xFFE0CDA1),
                    title: locales.settingsScreenWowExeFilePickerLabel,
                    context: context,
                    rootDirectory: dirPath,
                    fsType: FilesystemType.file,
                    allowedExtensions: ['.exe'],
                    pickText: 'Select',
                    fileTileSelectMode: FileTileSelectMode.wholeTile,
                  );

                  if (path != null) {
                    screenCubit.changeWowFilePath(path);
                  }
                } catch (e) {
                  if (!context.mounted) return;

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        locales.settingsScreenSetWowPathManuallyDriveException,
                      ),
                      content: Text(
                        '${locales.settingsScreenDriveAccessError} $drive\n\n$e',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(locales.ok),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
        SizedBox(height: spacing.sm),
        Text(
          locales.settingsScreenWowPathDrivesBtnHint,
          style: text.hintText,
        ),
      ],
    );
  }
}
