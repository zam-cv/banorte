import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/screens/profile.dart'; // Asegúrate de tener importada la pantalla Profile

class HeaderHome extends StatelessWidget {
  final int number;

  const HeaderHome({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    // Cálculo para el numerador y denominador
    int denominator = (number <= 7) ? 7 : ((number / 7).ceil() * 7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      color: Theme.of(context).colorScheme.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icono de fuego (lado izquierdo)
          Row(
            children: [
              SvgPicture.asset(
                'assets/fire.svg', // Ruta del icono fire.svg
                height: 24, // Ajusta el tamaño del icono
                colorFilter: ColorFilter.mode(
                  Theme.of(context)
                      .colorScheme
                      .primary, // Aplicar el color primario del tema
                  BlendMode.srcIn,
                ),
              ),

              const SizedBox(width: 8), // Espacio entre el icono y el texto
              Text(
                '$number/$denominator',
                style: TextStyle(
                  color: Colors.grey, // Color blanco
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Logo (centro) con el color principal del tema
          SvgPicture.asset(
            'assets/logo.svg', // Ruta del logo.svg
            height: 24, // Ajusta el tamaño del logo
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary, // Color del tema
              BlendMode.srcIn,
            ),
          ),
          // Icono de usuario (lado derecho) envuelto en GestureDetector
          GestureDetector(
            onTap: () {
              // Navegamos a Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: SvgPicture.asset(
              'assets/user.svg', // Ruta del icono user.svg
              height: 24, // Ajusta el tamaño del icono
              colorFilter: ColorFilter.mode(
                Theme.of(context)
                    .colorScheme
                    .primary, // Aplicar el color primario
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
