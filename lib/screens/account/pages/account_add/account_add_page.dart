import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_add/cubit/account_add_page_cubit.dart';
import '../../../../data/account.dart';
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

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<AccountScreenCubit>();
    final pageCubit = context.read<AccountAddPageCubit>();
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
            BlocConsumer<AccountAddPageCubit, AccountAddPageState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Row(
                      children: [
                        MyTextField(
                          myController: _accPasswordController,
                          hint: 'Account Passwort',
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
                            showPw = !showPw;
                            pageCubit.changeVisibility(showPw);
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
              listener: (context, state) => state.whenOrNull(
                accountAdded: () => screenCubit.initialize(),
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
                  child: Text('Zurück'),
                ),
                SizedBox(width: 160),
                ElevatedButton(
                  onPressed: () {
                    if (_listNameController.text.isEmpty ||
                        _accNameController.text.isEmpty ||
                        _accPasswordController.text.isEmpty) {
                      return;
                    }
                    pageCubit.addAccount(
                        Account(
                            accId: 0,
                            listName: _listNameController.text,
                            accountName: _accNameController.text,
                            accountRealm: 'logon.rising-gods.de',
                            accChars: []),
                        _accPasswordController.text);
                  },
                  child: const Text('Speichern'),
                ),
              ],
            ),
          ],
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
