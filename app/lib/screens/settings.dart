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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Fijo: AppBar customizado con el logo en la parte superior azul
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/logo.svg', // Logo en SVG
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary, // Color del logo
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 5),
                // Título "Ajustes" usando los estilos del Theme
                Text(
                  'Ajustes',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white, // Color blanco
                      ),
                ),
              ],
            ),
          ),
          // Contenido de los ajustes
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón "Conócenos" con el estilo del Theme
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Button(
                      text: 'Conócenos',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.home);
                      },
                      child: Text(
                        'Conócenos',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white, // Color del texto del botón
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Texto "¿Ya tienes cuenta?" usando los estilos del Theme
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Botón de Registro con el enlace de Banorte
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
                      child: Text(
                        'Registrar',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white, // Color del texto del botón
                            ),
                      ),
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
}
