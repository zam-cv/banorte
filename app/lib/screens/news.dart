import 'dart:math'; // Importar la clase Random
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_nav.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 1;
  bool _showSplash = true; //Splash screen
  final List<String> imagePaths = [
    "assets/noticia_muestra.png",
    "assets/noticia_muestra2.png",
    "assets/noticia_muestra3.png",
    "assets/noticia_muestra4.png",
    "assets/noticia_muestra5.png",
    "assets/noticia_muestra6.png",
    "assets/noticia_muestra7.png"
  ]; // Lista de imágenes para seleccionar aleatoriamente

  final List<String> newsTitles = [
    "Banorte lanza nuevas opciones de inversión digital",
    "Nuevas alianzas estratégicas de Banorte para mejorar servicios bancarios",
    "Banorte presenta plataforma para pagos internacionales",
    "Innovaciones tecnológicas en la banca móvil de Banorte",
    "Banorte impulsa el financiamiento para pequeñas y medianas empresas",
    "Banorte expande su red de cajeros automáticos inteligentes",
    "Seguridad digital: Banorte fortalece sus sistemas de protección en línea",
    "Banorte reduce comisiones en transferencias internacionales",
    "Nuevos créditos hipotecarios de Banorte con tasas competitivas",
    "Banorte lanza programa de apoyo financiero a emprendedores"
  ];

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // Fondo claro
      body: _showSplash
          ? _buildSplashScreen(
              context) // Muestra la splash screen si es necesario
          : _buildMainContent(context), // Muestra el contenido principal
      bottomNavigationBar: CustomNavBar(
        onTabSelected: _onItemTapped, // Función para manejar las selecciones
        selectedIndex: _selectedIndex, // Noticias está seleccionada
      ),
    );
  }

  // Splash Screen con el icono `news_icon.svg`
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
              'assets/news_icon.svg', // Ruta del icono de noticias en SVG
              height: 50, // Ajusta el tamaño del icono
              fit: BoxFit.contain, // Asegura que la imagen no se distorsione
            ),
            const SizedBox(height: 20),
            Text(
              'Noticias',
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

  // Contenido principal después de la splash screen
  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        // Fijo: AppBar customizado con el logo en la parte superior azul
        Container(
          width: double.infinity,
          color: Theme.of(context)
              .colorScheme
              .secondary, // Fondo azul para el logo
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/logo.svg', // Logo en SVG
                height: 30,
                colorFilter: ColorFilter.mode(
                  Theme.of(context)
                      .colorScheme
                      .primary, // Logo con el color principal del tema
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Noticias', // Título de la página
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      // Aplicar el tema para títulos grandes
                    ),
              ),
            ],
          ),
        ),
        // Lista desplazable de noticias
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: List.generate(
                  10,
                  (index) =>
                      buildNewsPost(context)), // Repite la noticia 10 veces
            ),
          ),
        ),
      ],
    );
  }

  // Widget de una noticia individual
  Widget buildNewsPost(BuildContext context) {
    final random = Random(); // Instancia para generar aleatoriedad
    String randomImage = imagePaths[
        random.nextInt(imagePaths.length)]; // Selección aleatoria de la imagen
    String randomTitle = newsTitles[
        random.nextInt(newsTitles.length)]; // Selección aleatoria del título

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x84131B44), // Color con 52% de opacidad
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la noticia
            Text(
              randomTitle, // Título seleccionado aleatoriamente
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white, // Aplicar el estilo de títulos grandes
                  ),
            ),
            const SizedBox(height: 10),
            // Contenido del texto
            Text(
              'Los clientes de la banca móvil de Grupo Financiero Banorte ahora pueden realizar pagos a cualquier parte del mundo y en diversas monedas, como dólar americano, euro, libra esterlina, franco suizo, dólar canadiense, dólar australiano, corona noruega y corona sueca.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white, // Aplicar el estilo de cuerpo
                  ),
            ),
            const SizedBox(height: 20),
            // Imagen de la noticia, seleccionada aleatoriamente
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                randomImage, // Ruta de la imagen seleccionada aleatoriamente
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
