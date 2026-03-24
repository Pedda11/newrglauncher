import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  final _formKey = GlobalKey<FormState>();

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
                child: Row(
                  children: [
                    MyTextField(
                      myController: _accPasswordController,
                      hint: locales.accountAddPagePasswordHint,
                      obscure: !showPw,
                    ),
                    IconButton(
                      icon: showPw
                          ? const Icon(
                              Icons.visibility,
                              size: 24,
                            )
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
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
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

                      pageCubit.addAccount(
                        Account(
                          accId: 0,
                          listName: _listNameController.text,
                          accountName: _accNameController.text,
                          accountRealm: 'logon.rising-gods.de',
                          accChars: [],
                        ),
                        _accPasswordController.text,
                      );
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

  @override
  void dispose() {
    _listNameController.dispose();
    _accNameController.dispose();
    _accPasswordController.dispose();
    super.dispose();
  }
}
