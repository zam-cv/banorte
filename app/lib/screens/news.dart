import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_nav.dart'; // Asegúrate de importar el CustomNavBar existente

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 1; // Noticias está seleccionada

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Aquí puedes añadir lógica de navegación si es necesario
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // Fondo claro
      body: Column(
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
      ),
      // Utiliza la navbar existente desde el archivo importado
      bottomNavigationBar: CustomNavBar(
        onTabSelected: _onItemTapped, // Función para manejar las selecciones
        selectedIndex: _selectedIndex, // Noticias está seleccionada
      ),
    );
  }

  // Widget de una noticia individual
  Widget buildNewsPost(BuildContext context) {
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
              'Apoyo de Banorte móvil',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors
                        .white, // Aplicar el estilo de títulos grandes (Gotham)
                  ),
            ),
            const SizedBox(height: 10),
            // Contenido del texto
            Text(
              'Los clientes de la banca móvil de Grupo Financiero Banorte ahora pueden realizar pagos a cualquier parte del mundo y en diversas monedas, como dólar americano, euro, libra esterlina, franco suizo, dólar canadiense, dólar australiano, corona noruega y corona sueca.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white, // Aplicar el estilo de cuerpo (Roboto)
                  ),
            ),
            const SizedBox(height: 20),
            // Imagen de la noticia
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/noticia_muestra.png', // Ruta de la imagen
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
