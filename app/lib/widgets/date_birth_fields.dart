import 'package:flutter/material.dart';
import 'package:app/widgets/custom_text_field.dart'; // Usamos el CustomTextField previamente creado

class DateOfBirthFields extends StatelessWidget {
  const DateOfBirthFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha de nacimiento',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: CustomTextField(hintText: 'dd'),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: CustomTextField(hintText: 'mm'),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: CustomTextField(hintText: 'aa'),
            ),
          ],
        ),
      ],
    );
  }
}
