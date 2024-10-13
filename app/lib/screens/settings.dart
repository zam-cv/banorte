import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_nav.dart'; // Asegúrate de importar la navbar existente
import 'package:app/widgets/button.dart';
import 'package:app/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SettingsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navegación a otras páginas si es necesario
    });
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/logo.svg', // Logo en SVG
                  height: 30,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Ajustes', // Título de la página
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Contenido del
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campos de texto
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Button(
                      text: 'Conócenos',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.home);
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Texto para iniciar sesión
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '¿Ya tienes cuenta? ',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Botón de Registro que abre el enlace de Banorte
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Button(
                      text: 'Registrar',
                      onPressed: () async {
                        const url = 'https://www.google.com/';
                        final Uri uri = Uri.parse(url);

                        // Lógica para abrir el enlace
                        try {
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode
                                  .externalApplication, // Para móviles
                            );
                          } else {
                            throw 'No se pudo abrir $url';
                          }
                        } catch (e) {
                          // Muestra un diálogo o snackbar si falla la apertura del enlace
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error al abrir el enlace: $e')),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20), // Padding extra debajo del botón
                ],
              ),
            ),
          ),
        ],
      ),
      // Navbar existente
      bottomNavigationBar: CustomNavBar(
        onTabSelected: _onItemTapped, // Función para manejar las selecciones
        selectedIndex: _selectedIndex, // Perfil está seleccionada
      ),
    );
  }

  // Widget para las rachas con el ícono de fuego
  Widget buildStreakTile(
      BuildContext context, String title, String count, String iconPath) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x84131B44), // Fondo oscuro con 52% de opacidad
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath, // Ícono de fuego
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
