import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necesario para los inputFormatters
import 'package:app/widgets/custom_num_field.dart'; // Asumo que este widget está basado en el TextField

class DateOfBirthFields extends StatelessWidget {
  // Controladores para día, mes y año
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;

  // Constructor que acepta los controladores
  const DateOfBirthFields({
    super.key,
    required this.dayController,
    required this.monthController,
    required this.yearController,
  });

  // Método que combina los campos en una fecha completa
  String getDateOfBirth() {
    return '${dayController.text}/${monthController.text}/${yearController.text}';
  }

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
            // Campo para día (2 dígitos)
            Expanded(
              child: CustomNumField(
                controller: dayController, // Añadimos el controlador
                hintText: 'dd',

                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2), // Limita a 2 dígitos
                ],
              ),
            ),
            const SizedBox(width: 5),
            // Campo para mes (2 dígitos)
            Expanded(
              child: CustomNumField(
                controller: monthController, // Añadimos el controlador
                hintText: 'mm',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2), // Limita a 2 dígitos
                ],
              ),
            ),
            const SizedBox(width: 5),
            // Campo para año (4 dígitos)
            Expanded(
              child: CustomNumField(
                controller: yearController, // Añadimos el controlador
                hintText: 'aaaa',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4), // Limita a 4 dígitos
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
