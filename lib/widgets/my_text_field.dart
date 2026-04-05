import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: SizedBox(
        width: 333,
        child: TextFormField(
          key: fieldKey,
          controller: myController,
          obscureText: obscure,
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
        ),
      ),
    );
  }
}
