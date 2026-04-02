import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../repository/credential_repository.dart';
import '../../../../repository/main_repository.dart';
import '../../../../screens/account/pages/account_add/cubit/account_add_page_cubit.dart';
import '../../../../data/account.dart';
import '../../../../localization/generated/l10n.dart';
import '../../../../widgets/my_appbar.dart';
import '../../../../widgets/my_text_field.dart';
import '../../cubit/account_cubit/account_screen_cubit.dart';

class AccountAddPage extends StatefulWidget {
  const AccountAddPage({super.key});

  @override
  State<AccountAddPage> createState() => _AccountAddPageState();
}

class _AccountAddPageState extends State<AccountAddPage> {
  final _listNameController = TextEditingController();
  final _accNameController = TextEditingController();
  final _accPasswordController = TextEditingController();

  bool showPw = false;
  bool goldTrendValue = false;
  Account? account;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final currentAccount = context.read<MainRepository>().account;

    if (currentAccount == null) {
      return;
    }

    _listNameController.text = currentAccount.listName;
    _accNameController.text = currentAccount.accountName;

    final password =
        await CredentialRepository().readPassword(currentAccount.uniqueId) ??
            '';

    if (!mounted) {
      return;
    }

    setState(() {
      account = currentAccount;
      _accPasswordController.text = password;
      goldTrendValue = currentAccount.includeInGoldTrend;
    });
  }

  @override
  void dispose() {
    _listNameController.dispose();
    _accNameController.dispose();
    _accPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<AccountScreenCubit>();
    final pageCubit = context.read<AccountAddPageCubit>();
    final locales = Localize.of(context);

    return Scaffold(
      appBar: MyAppbar(title: locales.accountAddPageNewAccount),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                myController: _listNameController,
                hint: locales.accountAddPageListNameHint,
                obscure: false,
              ),
              MyTextField(
                myController: _accNameController,
                hint: locales.accountAddPageAccountNameHint,
                obscure: false,
              ),
              BlocListener<AccountAddPageCubit, AccountAddPageState>(
                listener: (context, state) => state.whenOrNull(
                  accountAdded: () => screenCubit.initialize(),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        MyTextField(
                          myController: _accPasswordController,
                          hint: locales.accountAddPagePasswordHint,
                          obscure: !showPw,
                        ),
                        IconButton(
                          icon: showPw
                              ? const Icon(Icons.visibility, size: 24)
                              : const Icon(Icons.visibility_off, size: 24),
                          onPressed: () {
                            setState(() {
                              showPw = !showPw;
                            });
                            pageCubit.changeVisibility(showPw);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: goldTrendValue,
                          onChanged: (bool? newValue) {
                            setState(() {
                              goldTrendValue = newValue ?? false;
                            });
                          },
                        ),
                        const Text('Include in Gold Trend'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<MainRepository>().account = null;
                      screenCubit.initialize();
                    },
                    child: Text(locales.accountAddPageBackButton),
                  ),
                  const SizedBox(width: 160),
                  ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      if (account == null) {
                        pageCubit.addAccount(
                          Account(
                            accId: 0,
                            uniqueId: '',
                            listName: _listNameController.text,
                            accountName: _accNameController.text,
                            accountRealm: 'logon.rising-gods.de',
                            accChars: [],
                            includeInGoldTrend: goldTrendValue,
                          ),
                          _accPasswordController.text,
                        );
                      } else {
                        pageCubit.editAccount(
                          Account(
                            accId: account!.accId,
                            uniqueId: account!.uniqueId,
                            listName: _listNameController.text,
                            accountName: _accNameController.text,
                            accountRealm: 'logon.rising-gods.de',
                            accChars: account!.accChars,
                            includeInGoldTrend: goldTrendValue,
                          ),
                          _accPasswordController.text,
                        );
                      }
                    },
                    child: Text(locales.accountAddPageSaveButton),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
