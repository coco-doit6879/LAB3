import 'package:flutter/material.dart';

/// Native form semantics, focus, validation and disabled states share AppTheme.
class AppField extends StatelessWidget {
  const AppField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.decoration = const InputDecoration(),
    this.validator,
    this.onChanged,
  });
  final TextEditingController controller;
  final bool enabled;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final InputDecoration decoration;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    enabled: enabled,
    maxLength: maxLength,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    decoration: decoration,
    validator: validator,
    onChanged: onChanged,
  );
}
