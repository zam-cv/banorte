import 'dart:convert'; // Biblioteca necesaria para decodificar y codificar JSON.
import 'package:flutter/gestures.dart'; // Para manejar gestos, como taps en textos.
import 'package:flutter/material.dart'; // Biblioteca principal de Flutter para construir la UI.
import 'package:flutter_svg/flutter_svg.dart'; // Biblioteca para manejar imágenes en formato SVG.
import 'package:app/widgets/custom_input.dart'; // Widget personalizado para los campos de texto.
import 'package:app/widgets/custom_input_password.dart'; // Widget personalizado para los campos de contraseña.
import 'package:app/widgets/custom_button.dart'; // Widget personalizado para botones.
import 'package:app/routes/app_routes.dart'; // Definición de rutas para la navegación dentro de la app.
import 'package:app/widgets/date_birth_fields.dart'; // Widget personalizado para manejar la fecha de nacimiento.
import 'package:app/services/auth_service.dart'; // Servicio de autenticación para manejar peticiones HTTP.

/// Clase Signup que extiende StatefulWidget para manejar el estado dinámico de la pantalla de registro.
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() =>
      _SignupState(); // Método que crea el estado de la clase Signup.
}

/// Clase que define el estado de la pantalla de registro.
class _SignupState extends State<Signup> {
  // Controladores para manejar los datos ingresados por el usuario.
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  // Variable que indica si la solicitud de registro está en progreso.
  bool _loading = false;

  /// Método para obtener la fecha de nacimiento en formato dd/mm/yyyy.
  String getDateOfBirth() {
    return '${_dayController.text.padLeft(2, '0')}/${_monthController.text.padLeft(2, '0')}/${_yearController.text}';
  }

  /// Método que maneja el registro de un nuevo usuario.
  Future<void> _register() async {
    setState(() {
      _loading = true; // Inicia el estado de carga.
    });

    // Verificación si las contraseñas coinciden.
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog(
          'Las contraseñas no coinciden'); // Muestra un diálogo si no coinciden.
      setState(() {
        _loading = false; // Detiene el estado de carga.
      });
      return;
    }

    // Verificación si todos los campos están llenos.
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _dayController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _yearController.text.isEmpty) {
      _showErrorDialog(
          'Por favor, rellena todos los campos'); // Muestra un diálogo si faltan campos.
      setState(() {
        _loading = false; // Detiene el estado de carga.
      });
      return;
    }

    // Captura la fecha de nacimiento.
    String birthdate = getDateOfBirth();
    print('Fecha de Nacimiento: $birthdate'); // Para depuración.

    // Mapa con los datos que serán enviados en la solicitud HTTP.
    Map<String, String> registerData = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "email": _emailController.text,
      "birthdate": birthdate, // Fecha de nacimiento en formato adecuado.
      "password": _passwordController.text,
    };

    try {
      // Llamada al servicio de autenticación para realizar la solicitud POST.
      final response = await AuthService.post(
        "https://9c2d-201-98-213-10.ngrok-free.app/api/auth/register", // Cambia la URL según sea necesario.
        registerData,
        false, // La autenticación no es necesaria en esta solicitud.
      );

      // Para depuración, imprime el código de estado y el cuerpo de la respuesta.
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final responseData =
          jsonDecode(response.body); // Decodifica la respuesta en formato JSON.

      // Verifica si el código de estado es 201 y el mensaje indica éxito.
      if (response.statusCode == 201 &&
          responseData['message'] == 'Usuario registrado exitosamente') {
        // Registro exitoso: redirige al login.
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else if (response.statusCode == 409) {
        // El usuario ya existe: muestra un mensaje de error.
        _showErrorDialog(
            'El usuario ya está registrado. Por favor, inicia sesión.');
      } else {
        // Si falla, muestra el mensaje de error devuelto por el servidor.
        _showErrorDialog(responseData['message'] ?? 'Error en el registro.');
      }
    } catch (e) {
      // Si ocurre un error en la solicitud, imprime el error y muestra un diálogo.
      print('Error: $e');
      _showErrorDialog("Ocurrió un error. Por favor, intenta de nuevo.");
    }

    setState(() {
      _loading = false; // Finaliza el estado de carga.
    });
  }

  /// Método que muestra un diálogo de error.
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'), // Título del diálogo.
          content: Text(message), // Mensaje de error.
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(
                  context), // Cierra el diálogo al presionar "OK".
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Construcción de la interfaz gráfica de la pantalla de registro.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.secondary, // Color de fondo.
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 25, vertical: 10), // Padding para el contenido.
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra el contenido verticalmente.
            children: [
              Column(
                children: [
                  // Logo de la app.
                  SvgPicture.asset(
                    'assets/logo.svg', // Carga la imagen del logo en formato SVG.
                    width: 35,
                    height: 35,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .colorScheme
                          .primary, // Aplica color primario al logo.
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Título principal "¡Únete a Banorte AI!".
                  Text(
                    '¡Únete a Banorte AI!',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors
                              .black, // Cambia el color del texto a negro.
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centra el contenido de forma vertical.
                    children: [
                      // Campo de texto para el nombre.
                      CustomInput(
                        controller:
                            _firstNameController, // Controlador para el campo de nombre.
                        label: "Nombre(s)", // Etiqueta del campo.
                        hintText: "Nombre", // Texto de ayuda.
                      ),
                      // Campo de texto para los apellidos.
                      CustomInput(
                        controller:
                            _lastNameController, // Controlador para el campo de apellidos.
                        label: 'Apellidos', // Etiqueta del campo.
                        hintText: 'Apellido(s)', // Texto de ayuda.
                      ),
                      const SizedBox(height: 15),
                      // Campos personalizados para la fecha de nacimiento.
                      DateOfBirthFields(
                        dayController:
                            _dayController, // Controlador para el día.
                        monthController:
                            _monthController, // Controlador para el mes.
                        yearController:
                            _yearController, // Controlador para el año.
                      ),
                      // Campo de texto para el correo electrónico.
                      CustomInput(
                        controller:
                            _emailController, // Controlador para el campo de correo.
                        label: 'Correo electrónico', // Etiqueta del campo.
                        hintText: 'banorteai@ejemplo.com', // Texto de ayuda.
                      ),
                      // Campo de texto para la contraseña.
                      CustomInputPassword(
                        controller:
                            _passwordController, // Controlador para la contraseña.
                        label: 'Contraseña', // Etiqueta del campo.
                        hintText: '**********', // Texto de ayuda.
                      ),
                      // Campo de texto para confirmar la contraseña.
                      CustomInputPassword(
                        controller:
                            _confirmPasswordController, // Controlador para la confirmación de la contraseña.
                        label: 'Confirmar contraseña', // Etiqueta del campo.
                        hintText: '**********', // Texto de ayuda.
                      ),
                      const SizedBox(height: 15),
                      // Texto con enlace para ir al login.
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '¿Ya tienes cuenta? ', // Pregunta al usuario si ya tiene una cuenta.
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
                              text:
                                  'Inicia Sesión', // Enlace para redirigir al login.
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context,
                                      AppRoutes.login); // Redirige al login.
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Botón para registrar al usuario.
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: CustomButton(
                          text: 'Registrar',
                          onPressed: _register, // Llama al método de registro.
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors
                                      .white, // Indicador de carga mientras se registra.
                                )
                              : Text(
                                  'Registrar',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Colors
                                            .white, // Texto blanco para el botón.
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
