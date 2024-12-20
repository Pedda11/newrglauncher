import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/my_text_field.dart';
import '../cubit/settings_screen_cubit.dart';

class SettingsScreenContent extends StatefulWidget {
  const SettingsScreenContent({super.key});

  @override
  State<SettingsScreenContent> createState() => _SettingsScreenContentState();
}

class _SettingsScreenContentState extends State<SettingsScreenContent> {
  final _wowFilePathController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<SettingsScreenCubit>();
    //final folders = _getFolders(screenCubit);
    return BlocBuilder<SettingsScreenCubit, SettingsScreenState>(
      builder: (context, state) {
        return Placeholder();
        /*return state.whenOrNull(
              initial: () => Column(
                children: [
                  buildWowFilePathRow(screenCubit),
                  Expanded(child: buildDataDirectoryRow(screenCubit, folders)),
                ],
              ),
              settingsChanged: () => Column(
                children: [
                  buildWowFilePathRow(screenCubit),
                  Expanded(child: buildDataDirectoryRow(screenCubit, folders)),
                ],
              ),
            ) ??*/
            Container();
      },
    );
  }

  Widget buildWowFilePathRow(SettingsScreenCubit screenCubit) {
    _wowFilePathController.text =
        screenCubit.mainRepository.settingsRepository.wowExecutablePath ?? '';
    return Row(
      children: [
        SizedBox(
          width: 600,
          child: MyTextField(
            myController: _wowFilePathController,
            hint: 'WoW-Speicherort',
            obscure: false,
          ),
        ),
        IconButton(
          onPressed: () async {
            //screenCubit.changeWowFilePath(await _openFilePicker());
          },
          icon: Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.folder_outlined,
              size: 24,
            ),
          ),
        )
      ],
    );
  }

  Widget buildDataDirectoryRow(
      SettingsScreenCubit screenCubit, List<String> dataFolderList) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          width: 24,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: dataFolderList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  screenCubit.changeDataDirectory(dataFolderList[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.black, width: 1),
                    color: screenCubit.mainRepository.settingsRepository
                                .wowDataDirectory ==
                            dataFolderList[index]
                        ? Colors.green
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        dataFolderList[index],
                        style: TextStyle(
                          color: screenCubit.mainRepository.settingsRepository
                                      .wowDataDirectory ==
                                  dataFolderList[index]
                              ? Colors.white
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
