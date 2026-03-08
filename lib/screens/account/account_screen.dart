import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../localization/generated/l10n.dart';
import '../../widgets/my_appbar.dart';
import 'cubit/account_cubit/account_screen_cubit.dart';
import 'pages/account_add/account_add_page.dart';
import 'pages/account_list/account_list_page.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _pageViewController = PageController();
  Duration pageTransitionDuration = const Duration(milliseconds: 300);
  final pageTransitionCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    return Scaffold(
      appBar: MyAppbar(
        title: locales.accountListPageTitle,
        centerTitle: false,
      ),
      body: BlocListener<AccountScreenCubit, AccountScreenState>(
        listener: (context, state) {
          state.whenOrNull(
            initialized: () {
              _pageViewController.animateToPage(0,
                  duration: pageTransitionDuration, curve: pageTransitionCurve);
            },
            goToAddAccountPage: () {
              _pageViewController.animateToPage(1,
                  duration: pageTransitionDuration, curve: pageTransitionCurve);
            },
          );
        },
        child: PageView(
          controller: _pageViewController,
          children: const [
            AccountListPage(),
            AccountAddPage(),
          ],
          onPageChanged: (int index) {
            setState(() {
              _pageViewController.jumpToPage(index);
            });
          },
        ),
      ),
    );
  }
}
