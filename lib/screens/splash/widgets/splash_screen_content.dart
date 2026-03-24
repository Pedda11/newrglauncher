import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/data/disclaimer.dart';
import '../../../localization/generated/l10n.dart';
import '../../../navigation/navigation_pane.dart';
import '../../../repository/error_repository.dart';
import '../../../widgets/log.dart';
import '../cubit/splash_screen_cubit.dart';

class SplashScreenContent extends StatelessWidget {
  const SplashScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    final screenCubit = context.read<SplashScreenCubit>();
    return BlocConsumer<SplashScreenCubit, SplashScreenState>(
      listener: (context, state) {
        state.maybeWhen(
          initialized: () {
            return Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const NavigationPane(
                initialIndex: 0,
              ),
            ));
          },
          initializedFirstStart: () {
            return Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const NavigationPane(
                initialIndex: 1,
              ),
            ));
          },
          eulaNotAccepted: () async {
            bool isChecked = false;
            final hasAccepted = await showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text(locales.back),
                      content: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: SingleChildScrollView(
                                  child: Container(
                                      color: Colors.grey.shade100,
                                      padding: EdgeInsets.all(12),
                                      child: Text(Disclaimer.text)))),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                              ),
                              Text(locales.eulaAcceptText),
                            ],
                          )
                        ],
                      ),
                      actions: [
                        isChecked
                            ? TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(locales.accept),
                              )
                            : Container(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(locales.decline),
                        ),
                      ],
                    );
                  },
                );
              },
            );
            if (hasAccepted == null || !hasAccepted) {
              exit(0);
            } else {
              screenCubit.acceptEula();
            }
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          initial: () => const Center(
            child: SizedBox(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(),
            ),
          ),
          checkingForUpdates: () {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(locales.updateScreenUpdateCheck),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 120,
                    width: 120,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          },
          failed: (errorMsg) {
            return AlertDialog(
              title: Text(locales.error),
              content: Column(
                children: [
                  Text(
                    locales.errorHandlingContent,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(errorMsg),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(locales.ok),
                ),
              ],
            );
          },
          maintenance: () => Text(locales.splashScreenMaintenance),
          eulaNotAccepted: () => Text(locales.splashScreenEulaNotAccepted),
          initializedFirstStart: () =>
              Text(locales.splashScreenInitializedFirstStart),
          initialized: () => Text(locales.splashScreenInitialized),
          orElse: () {
            return const Center(
              child: SizedBox(
                  height: 120, width: 120, child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }
}
