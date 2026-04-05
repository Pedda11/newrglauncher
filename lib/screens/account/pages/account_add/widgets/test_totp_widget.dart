import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../services/totp/totp_service.dart';
import '../../../../../widgets/my_text_field.dart';

class TestTotpWidget extends StatefulWidget {
  final TextEditingController secretController;
  final ValueChanged<bool> onValidationChanged;

  const TestTotpWidget({
    super.key,
    required this.secretController,
    required this.onValidationChanged,
  });

  @override
  State<TestTotpWidget> createState() => _TestTotpWidgetState();
}

class _TestTotpWidgetState extends State<TestTotpWidget> {
  final _totPCodeController = TextEditingController();

  Timer? _countdownTimer;

  int countdown = 0;

  String isSecretValid = '';

  @override
  void initState() {
    super.initState();

    final totpService = TotpService();

    countdown = totpService.getSecondsRemaining();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        countdown = totpService.getSecondsRemaining();
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _totPCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$countdown'),
        MyTextField(
          fieldKey: const Key('account_add_totp_code'),
          myController: _totPCodeController,
          hint: 'auth code',
          obscure: false,
        ),
        ElevatedButton(
          key: const Key('account_add_totp_check_button'),
          onPressed: () {
            final totpService = TotpService();

            final inputCode = _totPCodeController.text;

            final isValid = totpService.isCodeValid(
              secret: widget.secretController.text,
              code: inputCode,
            );

            widget.onValidationChanged(isValid);

            setState(() {
              isSecretValid = isValid ? 'VALID' : 'INVALID';
            });
          },
          child: const Text('check'),
        ),
        const SizedBox(width: 16),
        Text(isSecretValid)
      ],
    );
  }
}
