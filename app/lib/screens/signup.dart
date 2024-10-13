import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/widgets/custom_input.dart';
import 'package:app/widgets/custom_input_password.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/widgets/date_birth_fields.dart';
import 'package:app/services/auth_service.dart'; // Importa el servicio de autenticación

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  bool _loading = false;

  // Método para obtener la fecha de nacimiento formateada
  String getDateOfBirth() {
    return '${_dayController.text.padLeft(2, '0')}/${_monthController.text.padLeft(2, '0')}/${_yearController.text}';
  }

  Future<void> _register() async {
    setState(() {
      _loading = true;
    });

    // Verificar si las contraseñas coinciden
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Las contraseñas no coinciden');
      setState(() {
        _loading = false;
      });
      return;
    }

    // Verificar si los campos no están vacíos
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _dayController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _yearController.text.isEmpty) {
      _showErrorDialog('Por favor, rellena todos los campos');
      setState(() {
        _loading = false;
      });
      return;
    }

    // Capturar la fecha de nacimiento
    String birthdate = getDateOfBirth();
    print('Fecha de Nacimiento: $birthdate');

    Map<String, String> registerData = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "email": _emailController.text,
      "birthdate": birthdate, // Usamos la fecha de nacimiento formateada
      "password": _passwordController.text,
    };

    try {
      final response = await AuthService.post(
        "https://9c2d-201-98-213-10.ngrok-free.app/api/auth/register", // Cambia la URL si es necesario
        registerData,
        false, // No requiere autenticación
      );

      // Imprime la respuesta completa para depuración
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final responseData = jsonDecode(response.body);

      // Verificar si el mensaje de éxito está presente y el código de estado es 201
      if (response.statusCode == 201 &&
          responseData['message'] == 'Usuario registrado exitosamente') {
        // Registro exitoso, redirigir al login
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else if (response.statusCode == 409) {
        // Usuario ya registrado
        _showErrorDialog(
            'El usuario ya está registrado. Por favor, inicia sesión.');
      } else {
        // Mostrar error en caso de que el registro falle
        _showErrorDialog(responseData['message'] ?? 'Error en el registro.');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog("Ocurrió un error. Por favor, intenta de nuevo.");
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
          title: const Text('Error'),
          content: Text(message),
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
                  // Título con estilo del Theme
                  Text(
                    '¡Únete a Banorte AI!',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.black,
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
                      CustomInput(
                        controller: _firstNameController,
                        label: "Nombre(s)",
                        hintText: "Carlos Rust",
                      ),
                      CustomInput(
                        controller: _lastNameController,
                        label: 'Apellidos',
                        hintText: 'Carlos Rust',
                      ),
                      const SizedBox(height: 15),
                      // Campo de Fecha de Nacimiento
                      DateOfBirthFields(
                        dayController: _dayController,
                        monthController: _monthController,
                        yearController: _yearController,
                      ),
                      CustomInput(
                        controller: _emailController,
                        label: 'Correo electrónico',
                        hintText: 'banorteai@ejemplo.com',
                      ),
                      CustomInputPassword(
                        controller: _passwordController,
                        label: 'Contraseña',
                        hintText: '**********',
                      ),
                      CustomInputPassword(
                        controller: _confirmPasswordController,
                        label: 'Confirmar contraseña',
                        hintText: '**********',
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '¿Ya tienes cuenta? ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            TextSpan(
                              text: 'Inicia Sesión',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, AppRoutes.login);
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: CustomButton(
                          text: 'Registrar',
                          onPressed: _register, // Llamar al método de registro
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Registrar',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
