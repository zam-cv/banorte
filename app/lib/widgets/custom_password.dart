import 'package:flutter/material.dart';
import 'package:app/widgets/custom_text_field.dart';

class CustomPassword extends StatefulWidget {
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  const CustomPassword(
      {super.key,
      this.hintText,
      this.obscureText = false,
      this.controller,
      this.keyboardType = TextInputType.visiblePassword,
      this.onChanged,
      this.contentPadding});

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<CustomPassword> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: widget.hintText,
      obscureText: _obscureText,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      contentPadding: widget.contentPadding,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            size: 23,
          ),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}
