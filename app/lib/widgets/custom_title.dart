import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String value;
  final Color? color;

  const CustomTitle({
    super.key,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(value,
        style:
            TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold));
  }
}
