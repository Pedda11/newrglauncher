import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/repository/main_repository.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_list/cubit/acc_list_page_cubit.dart';
import '../../../../localization/generated/l10n.dart';
import '../../../../widgets/my_appbar.dart';
import 'widgets/account_list_page_content.dart';

class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    return BlocProvider(
      create: (context) =>
          AccListPageCubit(mainRepository: context.read<MainRepository>())
            ..loadAccounts(),
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: MyAppbar(title: locales.accountListPageTitle),
        body: const Padding(
          padding: EdgeInsets.all(24.0),
          child: AccountListPageContent(),
        ),
      ),
    );
  }
}
