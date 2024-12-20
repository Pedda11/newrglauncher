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
    final locales = Localize.of(context);
    return BlocConsumer<SplashScreenCubit, SplashScreenState>(
      listener: (context, state) {
        state.maybeWhen(
          updateAvailable: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                icon: Icon(
                  Icons.update,
                  size: 80,
                  color: Colors.red,
                ),
                title: Text('UPDATE'),
                content:
                    Text('An update is available. Do you want to update now?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => NavigationPane(),
                      ));
                    },
                    child: Text('NO'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      UpdateService().updateApp();
                    },
                    child: Text('YES'),
                  ),
                ],
              ),
            );
          },
          initialized: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => NavigationPane(),
            ));
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          initial: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(locales.updateScreenUpdateCheck),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
          orElse: () {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(locales.updateScreenUpdateFound),
                  Text(locales.updateScreenUpdating),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: 120,
                      width: 120,
                      child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
