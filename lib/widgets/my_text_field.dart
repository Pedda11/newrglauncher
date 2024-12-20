
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  /// A custom text input field.
  const MyTextField({
    super.key,
    required this.myController,
    required this.hint,
    required this.obscure,
  });

  final TextEditingController myController;
  final String hint;
  final bool obscure;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: SizedBox(
        width: 333,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.myController,

                /// Using the provided controller to manage the text.
                style: const TextStyle(color: Colors.black),

                /// Setting the text color.
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.red,

                      /// Setting the border color when the field is enabled.
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  hintText: widget.hint,
                  labelText: widget.hint,

                  /// Providing a hint for the input.
                  hintStyle: TextStyle(
                      color: Colors.black.withAlpha(50),

                      /// Setting the hint text color.
                      fontWeight: FontWeight.bold),
                ),
                obscureText: widget.obscure,

                /// Handling the text visibility based on the 'obscure' parameter.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
