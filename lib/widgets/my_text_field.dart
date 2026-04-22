import 'package:flutter/material.dart';

import '../theme/helpers/theme_context_extensions.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.myController,
    required this.hint,
    required this.obscure,
    this.fieldKey,
  });

  final TextEditingController myController;
  final String hint;
  final bool obscure;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;
    final components = context.launcherComponents;

    return Padding(
      padding: EdgeInsets.only(top: spacing.sm),
      child: SizedBox(
        width: components.pinFieldWidth,
        child: TextFormField(
          key: fieldKey,
          controller: myController,
          obscureText: obscure,
          style: text.fieldValue.copyWith(
            color: colors.bodyText,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '';
            }
            return null;
          },
          decoration: InputDecoration(
            errorStyle: const TextStyle(height: 0),
            hintText: hint,
            hintStyle: text.pinFieldHint,
            filled: true,
            fillColor: colors.inputBackground.withValues(alpha: 0.92),
            contentPadding: EdgeInsets.symmetric(
              horizontal: components.inputContentHorizontalPadding,
              vertical: components.inputContentVerticalPadding,
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
              borderSide: BorderSide(
                color: colors.errorText,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.input),
              borderSide: BorderSide(
                color: colors.errorText,
                width: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
