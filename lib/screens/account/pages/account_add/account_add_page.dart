import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_add/widgets/test_totp_widget.dart';
import '../../../../repository/credential_repository.dart';
import '../../../../repository/main_repository.dart';
import '../../../../screens/account/pages/account_add/cubit/account_add_page_cubit.dart';
import '../../../../data/account.dart';
import '../../../../localization/generated/l10n.dart';
import '../../../../widgets/my_appbar.dart';
import '../../../../widgets/my_text_field.dart';
import '../../cubit/account_cubit/account_screen_cubit.dart';

class AccountAddPage extends StatefulWidget {
  final CredentialRepository credentialRepository;

  AccountAddPage({
    super.key,
    CredentialRepository? credentialRepository,
  }) : credentialRepository = credentialRepository ?? CredentialRepository();

  @override
  State<AccountAddPage> createState() => _AccountAddPageState();
}

class _AccountAddPageState extends State<AccountAddPage> {
  final _listNameController = TextEditingController();
  final _accNameController = TextEditingController();
  final _accPasswordController = TextEditingController();
  final _totPSecretController = TextEditingController();

  bool _showPw = false;
  bool _showTotP = false;
  bool _goldTrendValue = false;
  bool _isTotPEnabled = false;
  bool _isTotpSecretVerified = false;

  Account? _account;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _listNameController.addListener(_onFormChanged);
    _accNameController.addListener(_onFormChanged);
    _accPasswordController.addListener(_onFormChanged);
    _totPSecretController.addListener(_onTotpSecretChanged);
    _init();
  }

  Future<void> _init() async {
    final currentAccount = context.read<MainRepository>().account;

    if (currentAccount == null) {
      return;
    }

    _listNameController.text = currentAccount.listName;
    _accNameController.text = currentAccount.accountName;

    final password = await widget.credentialRepository
            .readPassword(currentAccount.uniqueId) ??
        '';
    final totpSecret = await widget.credentialRepository
        .readTotpSecret(currentAccount.uniqueId);

    if (!mounted) {
      return;
    }

    if (totpSecret != null && totpSecret.isNotEmpty) {
      _totPSecretController.text = totpSecret;
    }

    setState(() {
      _account = currentAccount;
      _accPasswordController.text = password;
      _goldTrendValue = currentAccount.includeInGoldTrend;
      _isTotPEnabled = currentAccount.isTotpEnabled;
      _isTotpSecretVerified = currentAccount.isTotpEnabled &&
          totpSecret != null &&
          totpSecret.isNotEmpty;
    });
  }

  void _onFormChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onTotpSecretChanged() {
    if (_isTotpSecretVerified) {
      _isTotpSecretVerified = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  bool get _isSaveEnabled {
    final listName = _listNameController.text.trim();
    final accountName = _accNameController.text.trim();
    final password = _accPasswordController.text.trim();
    final totpSecret = _totPSecretController.text.trim();

    if (listName.isEmpty || accountName.isEmpty || password.isEmpty) {
      return false;
    }

    if (_isTotPEnabled) {
      if (totpSecret.isEmpty) {
        return false;
      }

      if (!_isTotpSecretVerified) {
        return false;
      }
    }

    return true;
  }

  @override
  void dispose() {
    _listNameController.removeListener(_onFormChanged);
    _accNameController.removeListener(_onFormChanged);
    _accPasswordController.removeListener(_onFormChanged);
    _totPSecretController.removeListener(_onTotpSecretChanged);

    _listNameController.dispose();
    _accNameController.dispose();
    _accPasswordController.dispose();
    _totPSecretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageCubit = context.read<AccountAddPageCubit>();
    final locales = Localize.of(context);

    return BlocListener<AccountAddPageCubit, AccountAddPageState>(
      listener: (context, state) {
        state.whenOrNull(
          accountAdded: () => context.read<AccountScreenCubit>().initialize(),
        );
      },
      child: Scaffold(
        appBar: MyAppbar(title: locales.accountAddPageNewAccount),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextField(
                  fieldKey: const Key('account_add_list_name'),
                  myController: _listNameController,
                  hint: locales.accountAddPageListNameHint,
                  obscure: false,
                ),
                MyTextField(
                  fieldKey: const Key('account_add_account_name'),
                  myController: _accNameController,
                  hint: locales.accountAddPageAccountNameHint,
                  obscure: false,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MyTextField(
                          fieldKey: const Key('account_add_password'),
                          myController: _accPasswordController,
                          hint: locales.accountAddPagePasswordHint,
                          obscure: !_showPw,
                        ),
                        IconButton(
                          icon: _showPw
                              ? const Icon(Icons.visibility, size: 24)
                              : const Icon(Icons.visibility_off, size: 24),
                          onPressed: () {
                            setState(() {
                              _showPw = !_showPw;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _goldTrendValue,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _goldTrendValue = newValue ?? false;
                            });
                          },
                        ),
                        Text(locales.accountAddPageIncludeInGoldTrend),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _isTotPEnabled,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _isTotPEnabled = newValue ?? false;

                              if (!_isTotPEnabled) {
                                _isTotpSecretVerified = false;
                              }
                            });
                          },
                        ),
                        const Text('TOTP enabled'),
                      ],
                    ),
                    _isTotPEnabled
                        ? Row(
                            children: [
                              MyTextField(
                                fieldKey: const Key('account_add_totp_secret'),
                                myController: _totPSecretController,
                                hint: 'TOTP secret',
                                obscure: !_showTotP,
                              ),
                              IconButton(
                                icon: _showTotP
                                    ? const Icon(Icons.visibility, size: 24)
                                    : const Icon(Icons.visibility_off,
                                        size: 24),
                                onPressed: () {
                                  setState(() {
                                    _showTotP = !_showTotP;
                                  });
                                },
                              ),
                              const SizedBox(width: 16),
                              TestTotpWidget(
                                secretController: _totPSecretController,
                                onValidationChanged: (isValid) {
                                  setState(() {
                                    _isTotpSecretVerified = isValid;
                                  });
                                },
                              )
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<MainRepository>().account = null;
                        context.read<AccountScreenCubit>().initialize();
                      },
                      child: Text(locales.accountAddPageBackButton),
                    ),
                    const SizedBox(width: 160),
                    ElevatedButton(
                      key: const Key('account_add_save_button'),
                      onPressed: _isSaveEnabled
                          ? () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              if (_account == null) {
                                pageCubit.addAccount(
                                  Account(
                                    accId: 0,
                                    uniqueId: '',
                                    listName: _listNameController.text,
                                    accountName: _accNameController.text,
                                    accountRealm: 'logon.rising-gods.de',
                                    accChars: [],
                                    includeInGoldTrend: _goldTrendValue,
                                    isTotpEnabled: _isTotPEnabled,
                                  ),
                                  _accPasswordController.text,
                                  _totPSecretController.text,
                                );
                              } else {
                                pageCubit.editAccount(
                                  Account(
                                    accId: _account!.accId,
                                    uniqueId: _account!.uniqueId,
                                    listName: _listNameController.text,
                                    accountName: _accNameController.text,
                                    accountRealm: 'logon.rising-gods.de',
                                    accChars: _account!.accChars,
                                    includeInGoldTrend: _goldTrendValue,
                                    isTotpEnabled: _isTotPEnabled,
                                  ),
                                  _accPasswordController.text,
                                  _totPSecretController.text,
                                );
                              }
                            }
                          : null,
                      child: Text(locales.accountAddPageSaveButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
