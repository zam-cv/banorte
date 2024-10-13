import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/widgets/custom_input.dart';
import 'package:app/widgets/custom_input_password.dart';
import 'package:app/widgets/degraded.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/widgets/date_birth_fields.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Degraded(),
          // Fondo degradado o personalizado (puedes añadirlo si tienes un widget específico)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      // Logo
                      SvgPicture.asset(
                        'assets/logo.svg',
                        width: 35,
                        height: 35,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '¡Únete a Banorte AI!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Campos de texto
                          const CustomInput(
                            label: "Nombres(s)",
                            hintText: "Carlos Rust",
                          ),
                          const CustomInput(
                            label: 'Apellidos',
                            hintText: 'Carlos Rust',
                          ),
                          const CustomInput(
                            label: 'RFC (opcional)',
                            hintText: 'RFC12345678',
                          ),
                          const SizedBox(height: 15),
                          // Campo de Fecha de Nacimiento
                          const DateOfBirthFields(),
                          const CustomInput(
                            label: 'Correo electronico',
                            hintText: 'banorteai@ejemplo.com',
                          ),
                          const CustomInputPassword(
                            label: 'Contraseña',
                            hintText: '**********',
                          ),
                          const CustomInputPassword(
                            label: 'Confirmar contraseña',
                            hintText: '**********',
                          ),
                          const SizedBox(height: 15),
                          // Texto para iniciar sesión
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '¿Ya tienes cuenta? ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Inicia Sesión',
                                  style: const TextStyle(color: Colors.white),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Botón de Registro
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: CustomButton(
                              text: 'Registrar',
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.home);
                              },
                            ),
                          ),
                          const SizedBox(
                              height: 20), // Padding extra debajo del botón
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
