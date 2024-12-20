import 'package:flutter/material.dart';
import '../../../../localization/generated/l10n.dart';
import '../../../../widgets/my_appbar.dart';
import 'widgets/account_list_page_content.dart';

class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
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
