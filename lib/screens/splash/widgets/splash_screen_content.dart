import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../localization/generated/l10n.dart';
import '../../../navigation/navigation_pane.dart';
import '../../../services/update_service.dart';
import '../cubit/splash_screen_cubit.dart';

class SplashScreenContent extends StatelessWidget {
  const SplashScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashScreenCubit, SplashScreenState>(
      listener: (context, state) {
        state.maybeWhen(
          initialized: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => NavigationPane(),
            ));
          },
          orElse: () {},
        );
      },
      child: const Center(
        child: SizedBox.shrink(),
      ),
    );
  }
}
