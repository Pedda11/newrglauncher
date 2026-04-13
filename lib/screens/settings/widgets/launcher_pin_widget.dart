import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/screens/settings/widgets/pin_text_field.dart';

import '../../../enum/e_launcher_pin_mode.dart';
import '../../../localization/generated/l10n.dart';
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
    if (_errorText != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, top: 8),
        child: Text(
          _errorText!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_successText != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, top: 8),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PinTextField(
          fieldKey: const Key('launcher_pin_create'),
          myController: _pinController,
          hint: locales.launcherPinHintRepeat,
        ),
        PinTextField(
          fieldKey: const Key('launcher_pin_repeat'),
          myController: _repeatPinController,
          hint: locales.launcherPinHintRepeat,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _createPin,
            child: Text(locales.launcherPinButtonSave),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyCurrentPinUi() {
    final locales = Localize.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8),
          child: Text(locales.launcherPinActive),
        ),
        PinTextField(
          fieldKey: const Key('launcher_pin_current'),
          myController: _currentPinController,
          hint: locales.launcherPinHintCurrent,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyCurrentPinForChange,
                child: Text(locales.launcherPinButtonChange),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _deletePin,
                child: Text(locales.launcherPinButtonDisable),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChangePinUi() {
    final locales = Localize.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PinTextField(
          fieldKey: const Key('launcher_pin_new'),
          myController: _pinController,
          hint: locales.launcherPinHintNew,
        ),
        PinTextField(
          fieldKey: const Key('launcher_pin_new_repeat'),
          myController: _repeatPinController,
          hint: locales.launcherPinHintNewRepeat,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : _updatePin,
                child: Text(locales.launcherPinButtonUpdate),
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        _clearMessages();
                        _clearPinInputs();
                        setState(() {
                          _mode = ELauncherPinMode.verifyCurrent;
                        });
                      },
                child: Text(locales.launcherPinButtonCancel),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isPinEnabled,
              onChanged: _isLoading
                  ? null
                  : (value) async {
                      await _onPinCheckboxChanged(value ?? false);
                    },
            ),
            Text(locales.launcherPinLabel),
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
    );
  }
}
