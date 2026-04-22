import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/screens/account/pages/account_add/widgets/test_totp_widget.dart';
import '../../../../../repository/credential_repository.dart';
import '../../../../../repository/main_repository.dart';
import '../../../../../theme/helpers/theme_context_extensions.dart';
import '../../../../../widgets/launcher_button.dart';
import '../../../../../widgets/launcher_checkbox.dart';
import '../../../../../widgets/launcher_panel.dart';
import '../cubit/account_add_page_cubit.dart';
import '../../../../../data/account.dart';
import '../../../../../localization/generated/l10n.dart';
import '../../../../../widgets/my_appbar.dart';
import '../../../../../widgets/my_text_field.dart';
import '../../../cubit/account_cubit/account_screen_cubit.dart';

class AccountAddPageContent extends StatefulWidget {
  final CredentialRepository credentialRepository;

  AccountAddPageContent({
    super.key,
    CredentialRepository? credentialRepository,
  }) : credentialRepository = credentialRepository ?? CredentialRepository();

  @override
  State<AccountAddPageContent> createState() => _AccountAddPageContentState();
}

class _AccountAddPageContentState extends State<AccountAddPageContent> {
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
    final spacing = context.launcherSpacing;
    final text = context.launcherText;

    return Padding(
        padding: EdgeInsets.all(spacing.screenPadding),
        child: BlocListener<AccountAddPageCubit, AccountAddPageState>(
            listener: (context, state) {
              state.whenOrNull(
                accountAdded: () =>
                    context.read<AccountScreenCubit>().initialize(),
              );
            },
            child: LauncherPanel(
                child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _account == null
                          ? locales.accountAddPageNewAccount
                          : locales.accountAddPageSaveButton,
                      style: text.sectionTitle,
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      'Accountdaten und optionale 2FA-Einstellungen.',
                      style: text.sectionSubtitle,
                    ),
                    SizedBox(height: spacing.xl),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTextField(
                              fieldKey: const Key('account_add_password'),
                              myController: _accPasswordController,
                              hint: locales.accountAddPagePasswordHint,
                              obscure: !_showPw,
                            ),
                            SizedBox(width: spacing.md),
                            Padding(
                              padding: EdgeInsets.only(top: spacing.sm),
                              child: _VisibilityToggleButton(
                                isVisible: _showPw,
                                onPressed: () {
                                  setState(() {
                                    _showPw = !_showPw;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        _FormToggleRow(
                          value: _goldTrendValue,
                          onChanged: (newValue) {
                            setState(() {
                              _goldTrendValue = newValue;
                            });
                          },
                          label: locales.accountAddPageIncludeInGoldTrend,
                        ),
                        _FormToggleRow(
                          value: _isTotPEnabled,
                          onChanged: (newValue) {
                            setState(() {
                              _isTotPEnabled = newValue;

                              if (!_isTotPEnabled) {
                                _isTotpSecretVerified = false;
                              }
                            });
                          },
                          label: locales.totpEnabled,
                        ),
                        _isTotPEnabled
                            ? Padding(
                                padding: EdgeInsets.only(top: spacing.md),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(spacing.lg),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        context.launcherRadius.card),
                                    color: context
                                        .launcherColors.inputBackground
                                        .withValues(alpha: 0.55),
                                    border: Border.all(
                                      color: context.launcherColors.accent
                                          .withValues(alpha: 0.14),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        locales.totpEnabled,
                                        style: text.fieldLabel.copyWith(
                                          color:
                                              context.launcherColors.accentSoft,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: spacing.xs),
                                      Text(
                                        'Secret hinterlegen und mit einem aktuellen Code prüfen.',
                                        style: text.hintText,
                                      ),
                                      SizedBox(height: spacing.md),
                                      Wrap(
                                        spacing: spacing.md,
                                        runSpacing: spacing.md,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 333,
                                            child: MyTextField(
                                              fieldKey: const Key(
                                                  'account_add_totp_secret'),
                                              myController:
                                                  _totPSecretController,
                                              hint: locales.totpSecret,
                                              obscure: !_showTotP,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: spacing.sm),
                                            child: _VisibilityToggleButton(
                                              isVisible: _showTotP,
                                              onPressed: () {
                                                setState(() {
                                                  _showTotP = !_showTotP;
                                                });
                                              },
                                            ),
                                          ),
                                          TestTotpWidget(
                                            secretController:
                                                _totPSecretController,
                                            onValidationChanged: (isValid) {
                                              setState(() {
                                                _isTotpSecretVerified = isValid;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(height: spacing.xl),
                    Row(
                      children: [
                        LauncherButton(
                          label: locales.accountAddPageBackButton,
                          primary: false,
                          onPressed: () {
                            context.read<MainRepository>().account = null;
                            context.read<AccountScreenCubit>().initialize();
                          },
                        ),
                        const Spacer(),
                        LauncherButton(
                          key: const Key('account_add_save_button'),
                          label: locales.accountAddPageSaveButton,
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))));
  }
}

class _FormToggleRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const _FormToggleRow({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.launcherSpacing;
    final text = context.launcherText;
    final colors = context.launcherColors;

    return Padding(
      padding: EdgeInsets.only(top: spacing.md),
      child: Row(
        children: [
          LauncherCheckbox(
            value: value,
            onChanged: onChanged,
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Text(
              label,
              style: text.fieldValue.copyWith(
                color: colors.bodyText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisibilityToggleButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onPressed;

  const _VisibilityToggleButton({
    required this.isVisible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final radius = context.launcherRadius;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.input),
        color: colors.inputBackground.withValues(alpha: 0.92),
        border: Border.all(
          color: colors.accent.withValues(alpha: 0.14),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          size: 20,
          color: colors.mutedText,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
