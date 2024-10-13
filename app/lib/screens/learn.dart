import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  int _progress = 1; // Progreso inicial
  int _selectedOption = -1; // Ninguna opción seleccionada por defecto

  // Opciones
  final List<String> _options = ['8%', '10%', '16%', '18%'];

  void _selectOption(int index) {
    setState(() {
      _selectedOption = index;
    });
  }

  void _checkAnswer() {
    // Lógica para comprobar la respuesta aquí
    if (_progress < 10) {
      setState(() {
        _progress++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00020C), // Fondo oscuro
      body: Column(
        children: [
          // Fijo: AppBar customizado con el logo en la parte superior azul
          Container(
            width: double.infinity,
            color: const Color(0xFF070D2A), // Fondo azul para el logo
            padding: const EdgeInsets.symmetric(
                vertical: 10), // Espaciado vertical para el logo
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
              children: [
                SvgPicture.asset(
                  'assets/logo.svg', // Logo en SVG
                  height: 30,
                ),
                const SizedBox(height: 5), // Espaciado entre el logo y el texto
                const Text(
                  'Aprende', // Texto debajo del logo
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Fijo: Barra de progreso con el tache personalizado en la parte inferior negra
          Container(
            color: const Color(
                0xFF00020C), // Fondo negro para la barra de progreso
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
                const SizedBox(
                    width: 10), // Espaciado entre el tache y la barra
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

          // Desplazable: Contenido restante (preguntas, opciones, botón)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pregunta
                  const Text(
                    'Pregunta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color:
                          const Color(0x84131B44), // Color con 52% de opacidad
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '¿Cuál es el porcentaje actual del Impuesto al Valor Agregado (IVA) en México?',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Opciones
                  const Text(
                    'Opciones',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),

                  // Botón de comprobar
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
                      child: const Text(
                        'Comprobar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
