import 'package:flutter/material.dart';

/// A reusable custom text field widget that wraps [TextFormField].
///
/// This widget provides a consistent style for text inputs across the app
/// and reduces boilerplate code by encapsulating common configuration.
class CustomTextField extends StatelessWidget {
  /// Controller for managing the input text.
  final TextEditingController controller;

  /// Label to display inside the text field.
  final String label;

  /// Whether to obscure the text (useful for passwords).
  final bool obscureText;

  /// Optional validator function to validate input.
  final String? Function(String?)? validator;

  /// The type of keyboard to use for the text field.
  final TextInputType keyboardType;

  /// Callback for handling text changes.
  final ValueChanged<String>? onChanged;

  /// Maximum number of lines for the text field.
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        // You can customize the border style as needed
        border: const OutlineInputBorder(),
      ),
    );
  }
}
