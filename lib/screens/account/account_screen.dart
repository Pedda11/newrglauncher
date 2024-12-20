import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/main_repository.dart';
import '../../repository/preferences_repository.dart';
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
  final pageTransitionDuration = Duration(milliseconds: 300);
  final pageTransitionCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final mainRepository = context.read<MainRepository>();
    final preferencesRepository = context.read<PreferencesRepository>();
    return BlocProvider(
      create: (context) => AccountScreenCubit(
          mainRepository: mainRepository,
          preferencesRepository: preferencesRepository)
        ..initialize(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('data'),
        ),
        body: BlocListener<AccountScreenCubit, AccountScreenState>(
          listener: (context, state) {
            state.whenOrNull(
              initialized: (accountList) {
                _pageViewController.animateToPage(0,
                    duration: pageTransitionDuration,
                    curve: pageTransitionCurve);
              },
              noAccounts: () {
                _pageViewController.animateToPage(1,
                    duration: pageTransitionDuration,
                    curve: pageTransitionCurve);
              },
            );
          },
          child: PageView(
            controller: _pageViewController,
            children: [
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
      ),
    );
  }
}
