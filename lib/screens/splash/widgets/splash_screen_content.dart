import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../localization/generated/l10n.dart';
import '../../../navigation/navigation_pane.dart';
import '../../../repository/error_repository.dart';
import '../cubit/splash_screen_cubit.dart';

class SplashScreenContent extends StatelessWidget {
  const SplashScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    return BlocConsumer<SplashScreenCubit, SplashScreenState>(
      listener: (context, state) {
        state.maybeWhen(
          initialized: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const NavigationPane(),
            ));
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
            context.read<ErrorRepository>().sendErrorToServer(
                errorMessage: errorMsg,
                errorOnPosition: 'SplashScreenContent',
                errorDateTime: DateTime.now().toString());
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
