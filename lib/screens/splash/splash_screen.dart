import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_list/account_list_page.dart';
import 'package:twodotnulllauncher/screens/splash/widgets/splash_screen_content.dart';

import 'cubit/splash_screen_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<SplashScreenCubit, SplashScreenState>(
        listener: (context, state) {
          state.whenOrNull(
            initialized: () => Future.delayed(
              const Duration(seconds: 1),
              () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountListPage(),
                    ),
                    (route) => false);
              },
            ),
            isFirstLogin: () {
              /*return Future.delayed(
              const Duration(seconds: 1),
              () {
                Navigator.pushAndRemoveUntil(
                    context,
                    *//*MaterialPageRoute(
                      builder: (context) => const LoginScreenFirstLogin(),
                    ),*//*
                    //(route) => false);
              },
            );*/
            },
          );
        },
        child: const SplashScreenContent(),
      ),
    );
  }
}
