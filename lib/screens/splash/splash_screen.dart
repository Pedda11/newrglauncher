import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/splash_screen_cubit.dart';
import 'widgets/splash_screen_content.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SplashScreenCubit()
        ..initialize(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: const SplashScreenContent(),
      ),
    );
  }
}
