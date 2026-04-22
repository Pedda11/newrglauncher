import 'package:flutter/material.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_add/widgets/account_add_page_content.dart';
import '../../../../localization/generated/l10n.dart';
import '../../../../repository/credential_repository.dart';
import '../../../../theme/helpers/theme_context_extensions.dart';
import '../../../../widgets/my_appbar.dart';

class AccountAddPage extends StatefulWidget {
  final CredentialRepository credentialRepository;

  const AccountAddPage({super.key, required this.credentialRepository});

  @override
  State<AccountAddPage> createState() => _AccountAddPageState();
}

class _AccountAddPageState extends State<AccountAddPage> {
  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    return Scaffold(
      backgroundColor: context.launcherColors.windowBackground,
      appBar: MyAppbar(title: locales.accountAddPageNewAccount),
      body: AccountAddPageContent(
        credentialRepository: widget.credentialRepository,
      ),
    );
  }
}
