import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: SizedBox(
        width: 333,
        child: TextFormField(
          focusNode: focusNode,
          maxLength: 4,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          key: fieldKey,
          controller: myController,
          obscureText: true,
          style: const TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '';
            }
            return null;
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            errorStyle: const TextStyle(height: 0),
            hintText: hint,
            labelText: hint,
          ),
          onChanged: (value) {
            onChanged?.call(value);
          },
        ),
      ),
    );
  }
}
