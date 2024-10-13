import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para manejar JSON
import '../config.dart'; // Asegúrate de que este archivo contenga la URL base y el token

class PracticePage extends StatefulWidget {
  const PracticePage({Key? key}) : super(key: key);

  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  int _progress = 0; // Progreso inicial (0/10 correctas)
  int _selectedOption = -1; // Ninguna opción seleccionada por defecto
  bool _showSplash = true; // Controla si la splash screen se muestra
  bool _loadingQuestion = false; // Controla el estado de carga de la pregunta
  bool _completed =
      false; // Controla si el usuario ha terminado las 10 preguntas

  String? _question; // Pregunta actual
  List<String> _options = []; // Opciones actuales
  String? _correctAnswer; // Respuesta correcta de la API

  // URL de la API
  final String apiUrl = "${Config.baseUrl}/api/chat/practice"; // URL de la API

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showSplash = false;
        _loadQuestion(); // Cargar la primera pregunta después de la splash screen
      });
    });
  }

  // Función para cargar una nueva pregunta desde la API
  Future<void> _loadQuestion() async {
    setState(() {
      _loadingQuestion = true; // Mostrar un loader
      _selectedOption = -1; // Reiniciar la selección de opción
    });

    String? token = Config.token;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Response status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Datos recibidos: $data");

        setState(() {
          _question = data['question'];
          _options = List<String>.from(data['options']);
          _correctAnswer = data['correct_answer'];
          _loadingQuestion = false; // Ocultar loader
        });
      } else {
        // Manejo de error al cargar la pregunta
        print("Error al cargar pregunta: ${response.statusCode}");
        setState(() {
          _loadingQuestion = false;
        });
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      setState(() {
        _loadingQuestion = false;
      });
    }
  }

  // Función para seleccionar una opción
  void _selectOption(int index) {
    setState(() {
      _selectedOption = index;
    });
  }

  // Función para comprobar la respuesta
  void _checkAnswer() {
    setState(() {
      if (_options[_selectedOption] == _correctAnswer) {
        // Si la respuesta es correcta
        _progress++;
        if (_progress == 10) {
          _completed = true; // Finaliza si alcanzamos 10 correctas
        } else {
          _loadQuestion(); // Cargar la siguiente pregunta
        }
      } else {
        // Respuesta incorrecta: cargar una nueva pregunta
        _loadQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _showSplash
          ? _buildSplashScreen(
              context) // Muestra la splash screen si es necesario
          : _completed
              ? _buildCompletionScreen(context) // Pantalla de finalización
              : _buildMainContent(context), // Muestra el contenido principal
    );
  }

  Widget _buildSplashScreen(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/practice_icon.svg',
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              'Practica',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        // Fijo: AppBar customizado con el logo
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/logo.svg',
                height: 30,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Practica',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        // Barra de progreso
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Image.asset(
                  'assets/cross.png', // Reemplaza el tache por tu imagen
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LinearProgressIndicator(
                  value: _progress / 10, // Progreso dividido en 10
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
        // Contenido restante
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: _loadingQuestion
                ? const Center(
                    child: CircularProgressIndicator()) // Loader mientras carga
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pregunta',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _question ?? 'Cargando...',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Opciones',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: _options.asMap().entries.map((entry) {
                          int idx = entry.key;
                          String text = entry.value;
                          return GestureDetector(
                            onTap: () => _selectOption(idx),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _selectedOption == idx
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.8)
                                    : const Color(
                                        0x84131B44), // Color con 52% de opacidad
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _selectedOption == -1
                              ? null
                              : _checkAnswer, // Comprobar si hay una opción seleccionada
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Text(
                            'Comprobar',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // Pantalla cuando se completan las 10 preguntas
  Widget _buildCompletionScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¡Bien hecho!',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              'Volver al inicio',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
