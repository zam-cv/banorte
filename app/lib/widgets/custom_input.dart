import 'package:app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  const CustomInput({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto', // Aplica la fuente Roboto
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          keyboardType: keyboardType,
          controller: controller,
          suffixIcon: suffixIcon,
        ),
      ],
    );
  }
}
