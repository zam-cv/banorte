import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({Key? key}) : super(key: key);

  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  int _progress = 1; // Progreso inicial
  int _selectedOption = -1; // Ninguna opción seleccionada por defecto
  bool _showSplash = true; // Controla si la splash screen se muestra

  // Opciones
  final List<String> _options = ['8%', '10%', '16%', '18%'];

  @override
  void initState() {
    super.initState();

    // Iniciar el temporizador de la splash screen
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showSplash =
            false; // Mostrar el contenido principal después de 2 segundos
      });
    });
  }

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
        // Fijo: AppBar customizado con el logo en la parte superior azul
        Container(
          width: double.infinity, // Ocupa todo el ancho
          color: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(
              vertical: 10), // Espaciado vertical para el logo
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
        ),
        // Fijo: Barra de progreso con el tache personalizado en la parte inferior negra
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
        // Desplazable: Contenido restante (preguntas, opciones, botón)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pregunta
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
                    'Acabas de recibir un depósito de 15,000 pesos por concepto de tu salario. Sabes que tienes que destinar el 10% de tu salario al ahorro y, además, debes pagar un ISR del 20%. ¿Cuánto dinero te queda después de cumplir con ambas obligaciones?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                // Opciones
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
}
