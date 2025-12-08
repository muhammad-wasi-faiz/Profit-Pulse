import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData? icon;

  // Allow either hintText or labelText (one is enough)
  final String? hintText;
  final String? labelText;

  // Allow either obscure or obscureText (both do the same)
  final bool isObscure;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.hintText,
    this.labelText,
    bool? obscure,
    bool? obscureText,
  })  : isObscure = obscure ?? obscureText ?? false,
        assert(hintText != null || labelText != null,
        'Provide either hintText or labelText'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }
}