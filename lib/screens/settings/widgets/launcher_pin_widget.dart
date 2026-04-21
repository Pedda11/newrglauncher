import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/screens/settings/widgets/pin_text_field.dart';

import '../../../enum/e_launcher_pin_mode.dart';
import '../../../localization/generated/l10n.dart';
import '../../../theme/helpers/theme_context_extensions.dart';
import '../../../widgets/launcher_button.dart';
import '../../../widgets/launcher_checkbox.dart';
import '../../../widgets/launcher_panel.dart';
import '../cubit/settings_screen_cubit.dart';

class LauncherPinWidget extends StatefulWidget {
  const LauncherPinWidget({super.key});

  @override
  State<LauncherPinWidget> createState() => _LauncherPinWidgetState();
}

class _LauncherPinWidgetState extends State<LauncherPinWidget> {
  final _pinController = TextEditingController();
  final _repeatPinController = TextEditingController();
  final _currentPinController = TextEditingController();

  bool _isPinEnabled = false;
  bool _hasExistingPin = false;
  ELauncherPinMode _mode = ELauncherPinMode.disabled;

  String? _errorText;
  String? _successText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final cubit = context.read<SettingsScreenCubit>();

    final hasPin = await cubit.hasLauncherPin();

    if (!mounted) {
      return;
    }

    setState(() {
      _hasExistingPin = hasPin;
      _isPinEnabled = hasPin;
      _mode =
          hasPin ? ELauncherPinMode.verifyCurrent : ELauncherPinMode.disabled;
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _repeatPinController.dispose();
    _currentPinController.dispose();
    super.dispose();
  }

  void _clearMessages() {
    _errorText = null;
    _successText = null;
  }

  void _clearPinInputs() {
    _pinController.clear();
    _repeatPinController.clear();
    _currentPinController.clear();
  }

  bool _isValidPin(String value) {
    return RegExp(r'^\d{4}$').hasMatch(value);
  }

  Future<void> _onPinCheckboxChanged(bool value) async {
    _clearMessages();
    final locales = Localize.of(context);

    if (!value) {
      if (_hasExistingPin) {
        setState(() {
          _isPinEnabled = false;
          _mode = ELauncherPinMode.verifyCurrent;
          _errorText = locales.launcherPinDisabledConfirm;
        });
        return;
      }

      setState(() {
        _isPinEnabled = false;
        _mode = ELauncherPinMode.disabled;
      });
      return;
    }

    setState(() {
      _isPinEnabled = true;
      _mode = _hasExistingPin
          ? ELauncherPinMode.verifyCurrent
          : ELauncherPinMode.create;
    });
  }

  Future<void> _createPin() async {
    _clearMessages();
    final locales = Localize.of(context);

    final pin = _pinController.text.trim();
    final repeatPin = _repeatPinController.text.trim();

    if (!_isValidPin(pin)) {
      setState(() {
        _errorText = locales.launcherPinValidationDigits;
      });
      return;
    }

    if (pin != repeatPin) {
      setState(() {
        _errorText = locales.launcherPinMismatch;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<SettingsScreenCubit>().saveLauncherPin(pin);

      if (!mounted) {
        return;
      }

      setState(() {
        _hasExistingPin = true;
        _mode = ELauncherPinMode.verifyCurrent;
        _successText = locales.launcherPinSaved;
      });

      _clearPinInputs();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorText = '${locales.launcherPinSaveError}: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _verifyCurrentPinForChange() async {
    _clearMessages();
    final locales = Localize.of(context);

    final currentPin = _currentPinController.text.trim();

    if (!_isValidPin(currentPin)) {
      setState(() {
        _errorText = locales.launcherPinCurrentValidationDigits;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isValid = await context
          .read<SettingsScreenCubit>()
          .verifyLauncherPin(currentPin);

      if (!mounted) {
        return;
      }

      if (!isValid) {
        setState(() {
          _errorText = locales.launcherPinCurrentWrong;
        });
        return;
      }

      setState(() {
        _mode = ELauncherPinMode.change;
        _successText = locales.launcherPinCurrentConfirmed;
      });

      _currentPinController.clear();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorText = '${locales.launcherPinCheckError}: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updatePin() async {
    _clearMessages();
    final locales = Localize.of(context);

    final newPin = _pinController.text.trim();
    final repeatPin = _repeatPinController.text.trim();

    if (!_isValidPin(newPin)) {
      setState(() {
        _errorText = locales.launcherPinNewValidationDigits;
      });
      return;
    }

    if (newPin != repeatPin) {
      setState(() {
        _errorText = locales.launcherPinNewMismatch;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<SettingsScreenCubit>().saveLauncherPin(newPin);

      if (!mounted) {
        return;
      }

      setState(() {
        _mode = ELauncherPinMode.verifyCurrent;
        _successText = locales.launcherPinChanged;
      });

      _clearPinInputs();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorText = '${locales.launcherPinChangeError}: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deletePin() async {
    _clearMessages();
    final locales = Localize.of(context);

    final currentPin = _currentPinController.text.trim();

    if (!_isValidPin(currentPin)) {
      setState(() {
        _errorText = locales.launcherPinDisableValidationDigits;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isValid = await context
          .read<SettingsScreenCubit>()
          .verifyLauncherPin(currentPin);

      if (!mounted) {
        return;
      }

      if (!isValid) {
        setState(() {
          _errorText = locales.launcherPinCurrentWrong;
        });
        return;
      }

      await context.read<SettingsScreenCubit>().deleteLauncherPin();

      if (!mounted) {
        return;
      }

      setState(() {
        _hasExistingPin = false;
        _isPinEnabled = false;
        _mode = ELauncherPinMode.disabled;
        _successText = locales.launcherPinDisabled;
      });

      _clearPinInputs();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorText = '${locales.launcherPinDisableError}: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildMessage() {
    final spacing = context.launcherSpacing;

    if (_errorText != null) {
      return Padding(
        padding: EdgeInsets.only(top: spacing.sm),
        child: Text(
          _errorText!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_successText != null) {
      return Padding(
        padding: EdgeInsets.only(top: spacing.sm),
        child: Text(
          _successText!,
          style: const TextStyle(color: Colors.green),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCreatePinUi() {
    final locales = Localize.of(context);
    final spacing = context.launcherSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: spacing.md),
        PinTextField(
          fieldKey: const Key('launcher_pin_create'),
          myController: _pinController,
          hint: locales.launcherPinHintNew,
        ),
        SizedBox(height: spacing.md),
        PinTextField(
          fieldKey: const Key('launcher_pin_repeat'),
          myController: _repeatPinController,
          hint: locales.launcherPinHintRepeat,
        ),
        SizedBox(height: spacing.md),
        LauncherButton(
          label: locales.launcherPinButtonSave,
          onPressed: _isLoading ? null : _createPin,
        ),
      ],
    );
  }

  Widget _buildVerifyCurrentPinUi() {
    final locales = Localize.of(context);
    final spacing = context.launcherSpacing;
    final colors = context.launcherColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: spacing.md),
        Text(
          locales.launcherPinActive,
          style: TextStyle(
            color: colors.mutedText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: spacing.sm),
        PinTextField(
          fieldKey: const Key('launcher_pin_current'),
          myController: _currentPinController,
          hint: locales.launcherPinHintCurrent,
        ),
        SizedBox(height: spacing.md),
        Wrap(
          spacing: spacing.md,
          runSpacing: spacing.md,
          children: [
            LauncherButton(
              label: locales.launcherPinButtonChange,
              onPressed: _isLoading ? null : _verifyCurrentPinForChange,
            ),
            LauncherButton(
              label: locales.launcherPinButtonDisable,
              primary: false,
              onPressed: _isLoading ? null : _deletePin,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChangePinUi() {
    final locales = Localize.of(context);
    final spacing = context.launcherSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: spacing.md),
        PinTextField(
          fieldKey: const Key('launcher_pin_new'),
          myController: _pinController,
          hint: locales.launcherPinHintNew,
        ),
        SizedBox(height: spacing.md),
        PinTextField(
          fieldKey: const Key('launcher_pin_new_repeat'),
          myController: _repeatPinController,
          hint: locales.launcherPinHintNewRepeat,
        ),
        SizedBox(height: spacing.md),
        Wrap(
          spacing: spacing.md,
          runSpacing: spacing.md,
          children: [
            LauncherButton(
              label: locales.launcherPinButtonUpdate,
              onPressed: _isLoading ? null : _updatePin,
            ),
            LauncherButton(
              label: locales.launcherPinButtonCancel,
              primary: false,
              onPressed: _isLoading
                  ? null
                  : () {
                      _clearMessages();
                      _clearPinInputs();
                      setState(() {
                        _mode = ELauncherPinMode.verifyCurrent;
                      });
                    },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    final spacing = context.launcherSpacing;
    final colors = context.launcherColors;

    return LauncherPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Launcher-PIN',
            style: TextStyle(
              color: colors.titleText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            locales.launcherPinLabel,
            style: TextStyle(
              color: colors.mutedText,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          SizedBox(height: spacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LauncherCheckbox(
                value: _isPinEnabled,
                onChanged: _isLoading
                    ? null
                    : (value) async {
                        await _onPinCheckboxChanged(value);
                      },
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Text(
                  locales.launcherPinLabel,
                  style: TextStyle(
                    color: colors.bodyText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (_isPinEnabled &&
              !_hasExistingPin &&
              _mode == ELauncherPinMode.create)
            _buildCreatePinUi(),
          if (_isPinEnabled &&
              _hasExistingPin &&
              _mode == ELauncherPinMode.verifyCurrent)
            _buildVerifyCurrentPinUi(),
          if (_isPinEnabled &&
              _hasExistingPin &&
              _mode == ELauncherPinMode.change)
            _buildChangePinUi(),
          _buildMessage(),
        ],
      ),
    );
  }
}
