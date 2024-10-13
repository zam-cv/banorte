import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/custom_input.dart';
import 'package:app/widgets/custom_input_password.dart';
import 'package:app/config.dart';
import 'package:app/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false; // Indicador de carga

  Future<void> _login() async {
    final currentContext = context; // Guardar el contexto antes del await

    setState(() {
      _loading = true;
    });

    Map<String, String> credentials = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    try {
      final response = await AuthService.post(
        "${Config.baseUrl}/api/auth/login",
        credentials,
        false,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Config.token = data['token'];

        // Verificar la sesión con el token recibido
        final verifyResponse = await AuthService.verifySession();

        if (verifyResponse.statusCode == 200) {
          // Sesión verificada correctamente
          print("Sesión verificada correctamente.");
          // Redirigir a la pantalla principal
          Navigator.pushNamed(currentContext, AppRoutes.home);
        } else {
          // Error al verificar la sesión
          print("Error al verificar la sesión: ${verifyResponse.body}");
          _showErrorDialog("Error al verificar la sesión.");
        }
      } else {
        _showErrorDialog("Login failed. Please check your credentials.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred. Please try again.");
    }

    setState(() {
      _loading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .tertiary, // Color terciario para el título
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .tertiary, // Color terciario para el contenido
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: Column(
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 35,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    "Academia Financiera",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Educación Financiera en la palma de tu mano',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¡Bienvenido!',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                      ),
                      const SizedBox(height: 10),
                      CustomInput(
                        controller: _emailController, // Controlador del email
                        label: "Correo electronico",
                        hintText: "a51726553@gmail.com",
                      ),
                      const SizedBox(height: 15),
                      CustomInputPassword(
                        controller:
                            _passwordController, // Controlador del password
                        label: "Contraseña",
                        hintText: "**********",
                      ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppRoutes.forgotPassword);
                          },
                          child: Text(
                            'Olvidé mi contraseña',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '¿No tienes cuenta?  ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        TextSpan(
                          text: 'Regístrate',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, AppRoutes.signup);
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: CustomButton(
                      text: 'Iniciar sesión',
                      onPressed: _login, // Llamar a la función de login
                      child: _loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Iniciar sesión',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
