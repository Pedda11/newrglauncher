
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/account.dart';
import '../../../../repository/main_repository.dart';
import '../../../../widgets/my_appbar.dart';
import '../../../../widgets/my_text_field.dart';
import '../../cubit/account_cubit/account_screen_cubit.dart';

class AccountAddScreen extends StatefulWidget {
  const AccountAddScreen({super.key});

  @override
  State<AccountAddScreen> createState() => _AccountAddScreenState();
}

class _AccountAddScreenState extends State<AccountAddScreen> {
  final _listNameController = TextEditingController();
  final _accNameController = TextEditingController();
  final _accPasswordController = TextEditingController();
  final _realmController = TextEditingController();
  late AccountScreenCubit accCubit;
  late MainRepository accRepo;
  bool showPw = false;

  @override
  void initState() {
    accCubit = context.read<AccountScreenCubit>();
    accRepo = context.read<MainRepository>();
    super.initState();
  }

  ///Test change

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const MyAppbar(title: 'N e u e r   A c c o u n t'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              myController: _listNameController,
              hint: 'Listen Name',
              obscure: false,
            ),
            MyTextField(
              myController: _accNameController,
              hint: 'Account Name',
              obscure: false,
            ),
            BlocBuilder<AccountScreenCubit, AccountScreenState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Row(
                      children: [
                        MyTextField(
                          myController: _accPasswordController,
                          hint: 'Account Passwort',
                          obscure: true,
                        ),
                        Container(
                          child: IconButton(
                            icon: true
                                ? const Icon(
                                    Icons.visibility,
                                    size: 24,
                                  )
                                : const Icon(Icons.visibility_off, size: 24),
                            onPressed: () {
                              accCubit.changePwVisibility();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            context.read<AccountScreenCubit>().saveAccounts(
                                  Account(
                                      accId: 0,
                                      listName: _listNameController.text,
                                      accountName: _accNameController.text,
                                      accountPassword:
                                          _accPasswordController.text,
                                      accountRealm: _realmController.text == ''
                                          ? 'logon.rising-gods.de'
                                          : _realmController.text,
                                      accChars: []),
                                  accRepo,
                                );

                          },
                          tooltip: 'Speichern',
                          child: const Icon(Icons.person_add),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
