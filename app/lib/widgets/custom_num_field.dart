import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necesario para FilteringTextInputFormatter

class CustomNumField extends StatelessWidget {
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? suffixIcon;
  final List<TextInputFormatter>?
      inputFormatters; // Agregamos inputFormatters como parámetro opcional

  const CustomNumField({
    super.key,
    this.hintText,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 16.0,
    ),
    this.suffixIcon,
    this.inputFormatters, // Inicializamos inputFormatters
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: TextInputType.number, // Configura el teclado solo numérico
      onChanged: onChanged,
      inputFormatters: inputFormatters ??
          [
            FilteringTextInputFormatter.digitsOnly
          ], // Usamos inputFormatters si se proporcionan
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        contentPadding: contentPadding,
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondaryContainer,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
