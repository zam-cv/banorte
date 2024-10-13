import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math'; // Para seleccionar aleatoriamente
import 'package:app/config.dart'; // Importa Config para acceder al token

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  int _progress = 0; // Progreso inicial
  int _selectedOption = -1; // Ninguna opción seleccionada por defecto
  bool _showSplash = true; // Controla si la splash screen se muestra
  String _question = ''; // Pregunta actual
  List<String> _options = []; // Opciones actuales
  String _correctAnswer = ''; // Respuesta correcta actual

  // Vector con los elementos a elegir aleatoriamente
  final List<String> _contextOptions = [
    "seguridad",
    "Resiliencia",
    "control",
    "Libertad"
  ];

  @override
  void initState() {
    super.initState();
    _fetchQuestion(); // Llama al método para obtener la pregunta inicial
  }

  // Método para obtener la información de una nueva pregunta desde el backend
  Future<void> _fetchQuestion() async {
    setState(() {
      _showSplash =
          true; // Muestra la pantalla de carga mientras se obtiene la pregunta
    });

    // Verifica si el token está disponible
    if (Config.token == null) {
      print('Token no encontrado');
      return;
    }

    // Selecciona un elemento aleatorio del vector
    final String selectedContext =
        _contextOptions[Random().nextInt(_contextOptions.length)];

    // Construye la URL con el contexto seleccionado
    final String url =
        '${Config.baseUrl}/api/chat/message/salud financiera en el contexto de $selectedContext';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer ${Config.token}', // Añade el token al encabezado desde Config
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _question = data['question']; // Actualiza la pregunta
          _options =
              List<String>.from(data['options']); // Actualiza las opciones
          _correctAnswer =
              data['correct_answer']; // Actualiza la respuesta correcta
          _showSplash = false; // Oculta la pantalla de carga
          _selectedOption = -1; // Reinicia la opción seleccionada
        });
      } else {
        print('Error al obtener la pregunta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }

  // Método para seleccionar una opción
  void _selectOption(int index) {
    setState(() {
      _selectedOption = index;
    });
  }

  // Método para comprobar si la respuesta es correcta
  void _checkAnswer() {
    if (_selectedOption != -1) {
      String selectedOptionText = _options[_selectedOption];
      bool isCorrect = selectedOptionText == _correctAnswer;

      if (isCorrect) {
        setState(() {
          if (_progress < 10) {
            _progress++; // Incrementa el progreso si la respuesta es correcta
          }
        });
      }

      if (_progress == 10) {
        // Si se ha alcanzado el progreso máximo, navega a la pantalla principal
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Obtiene la siguiente pregunta
        _fetchQuestion();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _showSplash
          ? _buildSplashScreen(
              context) // Muestra la splash screen si es necesario
          : _buildMainContent(context), // Muestra el contenido principal
    );
  }

  Widget _buildSplashScreen(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      width: double.infinity, // Asegura que el ancho ocupe toda la pantalla
      height: double.infinity, // Asegura que el alto ocupe toda la pantalla
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/practice_icon.svg', // Ruta del icono de práctica en SVG
              height: 50, // Ajusta el tamaño del icono
              fit: BoxFit.contain, // Asegura que la imagen no se distorsione
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando...',
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
        _buildHeader(), // Barra superior con logo y título
        _buildProgressBar(context), // Barra de progreso
        // Desplazable: Contenido restante (preguntas, opciones, botón)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pregunta',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
                    _question, // Muestra la pregunta obtenida
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Opciones',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
                      onTap: () => _selectOption(idx), // Selecciona la opción
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
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                    ),
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
                    onPressed: _checkAnswer, // Comprobar respuesta
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary, // Color del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Text(
                      'Comprobar',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                          ),
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

  // Encabezado con logo y título
  Widget _buildHeader() {
    return Container(
      width: double.infinity, // Ocupa todo el ancho
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.symmetric(vertical: 10), // Espaciado vertical
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
        children: [
          SvgPicture.asset(
            'assets/logo.svg', // Logo en SVG
            height: 30,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 5), // Espaciado entre el logo y el texto
          Text(
            'Practica',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  // Barra de progreso
  Widget _buildProgressBar(BuildContext context) {
    return Container(
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
    );
  }
}
