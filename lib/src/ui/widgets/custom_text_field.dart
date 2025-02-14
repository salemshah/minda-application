import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  /// Controller to manage the input text.
  final TextEditingController controller;

  /// Icon to display at the start of the field (e.g., Icons.person).
  final IconData? prefixIcon;

  /// Hint text shown when the field is empty.
  final String hintText;

  /// Whether to obscure the text (useful for passwords).
  final bool obscureText;

  /// Optional validator function for validating input.
  final String? Function(String?)? validator;

  /// Content padding inside the TextFormField.
  final EdgeInsets contentPadding;


  const CustomTextFormField({
    super.key,
    required this.controller,
    this.prefixIcon,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.contentPadding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0)
        ),
        contentPadding: contentPadding,
      ),
    );
  }
}
