import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../services/totp/totp_service.dart';
import '../../../../../theme/helpers/theme_context_extensions.dart';
import '../../../../../widgets/launcher_button.dart';
import '../../../../../widgets/my_text_field.dart';
import '../../../../../localization/generated/l10n.dart';

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
    final locales = Localize.of(context);
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;

    final bool isValid = isSecretValid == 'VALID';
    final bool isInvalid = isSecretValid == 'INVALID';

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.input),
        color: colors.panelBackground.withValues(alpha: 0.55),
        border: Border.all(
          color: colors.panelBorder.withValues(alpha: 0.65),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locales.totpCheckButton,
            style: text.fieldLabel,
          ),
          SizedBox(height: spacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: spacing.xl * 2,
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius.button),
                  color: colors.inputBackground.withValues(alpha: 0.85),
                  border: Border.all(
                    color: colors.accent.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$countdown s',
                    style: text.hintText.copyWith(
                      color: colors.bodyText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.md),
              SizedBox(
                width: 180,
                child: MyTextField(
                  fieldKey: const Key('account_add_totp_code'),
                  myController: _totPCodeController,
                  hint: locales.totpAuthCodeHint,
                  obscure: false,
                ),
              ),
              SizedBox(width: spacing.md),
              Padding(
                padding: EdgeInsets.only(top: spacing.sm),
                child: LauncherButton(
                  label: locales.totpCheckButton,
                  onPressed: () {
                    final totpService = TotpService();

                    final inputCode = _totPCodeController.text;

                    final valid = totpService.isCodeValid(
                      secret: widget.secretController.text,
                      code: inputCode,
                    );

                    widget.onValidationChanged(valid);

                    setState(() {
                      isSecretValid = valid ? 'VALID' : 'INVALID';
                    });
                  },
                ),
              ),
            ],
          ),
          if (isSecretValid.isNotEmpty) ...[
            SizedBox(height: spacing.md),
            Row(
              children: [
                Icon(
                  isValid ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 18,
                  color: isValid ? text.statusSuccess.color : colors.errorText,
                ),
                SizedBox(width: spacing.sm),
                Text(
                  isValid ? 'Secret gültig' : 'Secret ungültig',
                  style: text.hintText.copyWith(
                    color:
                        isValid ? text.statusSuccess.color : colors.errorText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
