import 'dart:convert'; // Biblioteca necesaria para la decodificación y codificación de JSON.
import 'package:flutter/material.dart'; // Biblioteca principal de Flutter para el manejo de UI.
import 'package:flutter/gestures.dart'; // Para manejar gestos como Tap en los textos.
import 'package:flutter_svg/svg.dart'; // Para cargar imágenes SVG.
import 'package:app/routes/app_routes.dart'; // Importa las rutas definidas de la aplicación.
import 'package:app/widgets/custom_button.dart'; // Botón personalizado utilizado en la UI.
import 'package:app/widgets/custom_input.dart'; // Input de texto personalizado para el correo electrónico.
import 'package:app/widgets/custom_input_password.dart'; // Input de texto personalizado para contraseñas.
import 'package:app/config.dart'; // Configuración general de la aplicación.
import 'package:app/services/auth_service.dart'; // Servicio de autenticación (hace las peticiones HTTP).
import 'package:app/storage.dart'; // Para almacenamiento seguro de datos, como el token.

/// Clase Login que extiende StatefulWidget para manejar el estado.
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState(); // Crea el estado del login.
}

/// Clase que representa el estado de la pantalla Login.
class LoginState extends State<Login> {
  // Controladores para manejar el texto ingresado en los campos de correo y contraseña.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Booleano que indica si la aplicación está en proceso de autenticación.
  bool _loading = false;

  /// Función que maneja el inicio de sesión.
  Future<void> _login() async {
    setState(() {
      _loading =
          true; // Cambiamos el estado para mostrar el indicador de carga.
    });

    // Creamos un mapa con las credenciales ingresadas por el usuario.
    Map<String, String> credentials = {
      "email": _emailController.text, // Obtiene el correo del campo de texto.
      "password":
          _passwordController.text, // Obtiene la contraseña del campo de texto.
    };

    try {
      // Realiza una solicitud POST al servidor de autenticación.
      final response = await AuthService.post(
        "${Config.baseUrl}/api/auth/login", // URL del endpoint de login.
        credentials, // Cuerpo de la solicitud con las credenciales.
        false, // No requiere autenticación.
      );

      // Si la solicitud es exitosa (código 200), el token se almacena.
      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body); // Decodifica el cuerpo de la respuesta.
        Config.token =
            data['token']; // Almacena el token en la configuración global.
        print('Token recibido del backend: ${Config.token}');

        // Almacena el token de forma segura utilizando la clase Storage.
        await Storage.write('token', Config.token!);
        print('Token guardado en el almacenamiento');

        // Navega a la pantalla principal (Home) y limpia la pila de navegación.
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        // Si el login falla, se muestra un diálogo de error.
        _showErrorDialog("Login failed. Please check your credentials.");
      }
    } catch (e) {
      // En caso de error en la solicitud, muestra un diálogo con el mensaje de error.
      _showErrorDialog("An error occurred. Please try again.");
    }

    setState(() {
      _loading = false; // Finaliza la carga.
    });
  }

  /// Función que muestra un diálogo con un mensaje de error.
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
                  .tertiary, // Usa el color terciario del tema.
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .tertiary, // Usa el color terciario del tema.
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cierra el diálogo.
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Función que construye la interfaz de usuario del login.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.secondary, // Color de fondo secundario.
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 9.0), // Añade un padding vertical.
          child: Column(
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/logo.svg', // Carga el logo en formato SVG.
                    height: 35,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .colorScheme
                          .primary, // Color primario del logo.
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    "Academia Financiera", // Título de la app.
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .primary, // Color del texto primario.
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Educación Financiera en la palma de tu mano', // Subtítulo de la app.
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary, // Color del texto terciario.
                          fontWeight: FontWeight.bold, // Negrita para énfasis.
                        ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25), // Padding horizontal.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centra verticalmente los elementos.
                    children: [
                      Text(
                        '¡Bienvenido!', // Título de bienvenida.
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary, // Color terciario del texto.
                                ),
                      ),
                      const SizedBox(height: 10),
                      // Campo de entrada de correo electrónico.
                      CustomInput(
                        controller:
                            _emailController, // Controlador para el correo.
                        label: "Correo electronico", // Etiqueta del campo.
                        hintText: "a51726553@gmail.com", // Texto de ayuda.
                      ),
                      const SizedBox(height: 15),
                      // Campo de entrada de contraseña.
                      CustomInputPassword(
                        controller:
                            _passwordController, // Controlador para la contraseña.
                        label: "Contraseña", // Etiqueta del campo.
                        hintText: "**********", // Texto de ayuda.
                      ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context,
                                AppRoutes
                                    .forgotPassword); // Navega a la pantalla de recuperación de contraseña.
                          },
                          child: Text(
                            'Olvidé mi contraseña', // Texto del botón.
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, // Color primario del botón.
                                  fontWeight: FontWeight.bold, // Negrita.
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
                          text:
                              '¿No tienes cuenta?  ', // Texto antes del enlace.
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold, // Negrita.
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary, // Color primario.
                                  ),
                        ),
                        TextSpan(
                          text: 'Regístrate', // Texto con enlace para registro.
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary, // Color terciario.
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context,
                                  AppRoutes
                                      .signup); // Navega a la pantalla de registro.
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Botón de inicio de sesión.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25), // Padding horizontal.
                    child: CustomButton(
                      text: 'Iniciar sesión', // Texto del botón.
                      onPressed:
                          _login, // Llama a la función de inicio de sesión.
                      child: _loading
                          ? const CircularProgressIndicator(
                              color: Colors
                                  .white) // Muestra un indicador de carga si está en proceso.
                          : Text(
                              'Iniciar sesión', // Texto del botón cuando no hay carga.
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Colors
                                        .white, // Color del texto del botón.
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
