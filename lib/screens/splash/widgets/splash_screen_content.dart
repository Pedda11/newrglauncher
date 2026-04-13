import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/data/disclaimer.dart';
import 'package:twodotnulllauncher/repository/credential_repository.dart';
import 'package:twodotnulllauncher/screens/settings/widgets/pin_text_field.dart';
import '../../../localization/generated/l10n.dart';
import '../../../navigation/navigation_pane.dart';
import '../../../repository/error_repository.dart';
import '../../../utils/launcher_pin_utils.dart';
import '../../../widgets/log.dart';
import '../cubit/splash_screen_cubit.dart';

class SplashScreenContent extends StatefulWidget {
  const SplashScreenContent({super.key});

  @override
  State<SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<SplashScreenContent> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
                initialIndex: 3,
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
          pinSecured: () {
            _initialize();
            final pinController = TextEditingController();
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(locales.splashScreenPinPrompt),
                  const SizedBox(height: 16),
                  PinTextField(
                      focusNode: _focusNode,
                      myController: pinController,
                      hint: 'PIN',
                      onChanged: (p0) async {
                        final isValid = await LauncherPinUtils(
                                credentialRepository:
                                    context.read<CredentialRepository>())
                            .verifyLauncherPin(p0);
                        if (isValid) {
                          await screenCubit.pinSuccess();
                        }
                      }),
                  Text(pinController.text)
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
