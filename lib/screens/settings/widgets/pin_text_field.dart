import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/helpers/theme_context_extensions.dart';

class PinTextField extends StatelessWidget {
  final TextEditingController myController;
  final String hint;
  final Key? fieldKey;
  final Function(String)? onChanged;
  final FocusNode? focusNode;

  const PinTextField({
    super.key,
    required this.myController,
    required this.hint,
    this.fieldKey,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;

    return Padding(
      padding: EdgeInsets.only(top: spacing.sm),
      child: SizedBox(
        width: 333,
        child: TextFormField(
          focusNode: focusNode,
          key: fieldKey,
          controller: myController,
          maxLength: 4,
          obscureText: true,
          obscuringCharacter: '•',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: TextStyle(
            color: colors.bodyText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
          cursorColor: colors.accentStrong,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '';
            }
            return null;
          },
          decoration: InputDecoration(
            counterStyle: TextStyle(
              color: colors.mutedText,
              fontSize: 12,
            ),
            errorStyle: const TextStyle(height: 0),
            hintText: hint,
            hintStyle: TextStyle(
              color: colors.mutedText,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: colors.inputBackground.withValues(alpha: 0.92),
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.input),
              borderSide: BorderSide(
                color: colors.accent.withValues(alpha: 0.14),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.input),
              borderSide: BorderSide(
                color: colors.accent.withValues(alpha: 0.55),
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.input),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.input),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.4,
              ),
            ),
          ),
          onChanged: (value) {
            onChanged?.call(value);
          },
        ),
      ),
    );
  }
}
