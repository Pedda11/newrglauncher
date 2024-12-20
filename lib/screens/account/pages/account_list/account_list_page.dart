import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../localization/generated/l10n.dart';
import '../../../../repository/main_repository.dart';
import '../../../../widgets/my_appbar.dart';
import '../../cubit/account_cubit/account_screen_cubit.dart';
import 'widgets/account_list_page_content.dart';

class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    final screenCubit = context.read<AccountScreenCubit>()
      ..loadAccounts(context.read<MainRepository>());
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: MyAppbar(title: locales.addAccountScreenTitle),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: AccountListPageContent(),
      ),
    );
  }
}
