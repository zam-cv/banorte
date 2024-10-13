import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_nav.dart'; // Asegúrate de importar la navbar existente
import 'package:app/widgets/button.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/storage.dart'; // Importamos la clase Storage

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SettingsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode
              .externalApplication, // Abre en una aplicación externa (navegador)
        );
      } else {
        throw 'No se pudo abrir $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al abrir el enlace: $e'),
        ),
      );
    }
  }

  Future<void> _logout() async {
    // Eliminar el token del almacenamiento seguro
    await Storage.delete('token');

    // Redirigir al login después de eliminar el token
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (route) => false);
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
                        color: Theme.of(context).colorScheme.primary,
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
                  const SizedBox(height: 20), // Espacio arriba del texto
                  // Texto "Acerca de nosotros"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Acerca de nosotros',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Botón "Conócenos" con funcionalidad de URL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Button(
                      text: 'Conócenos',
                      onPressed: () {
                        _launchUrl('https://www.banorte.com/');
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Texto "Cuenta"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cuenta',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Botón "Ajustes de privacidad" con funcionalidad de URL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Button(
                      text: 'Ajustes de privacidad',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.home);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Botón "Perfil" con funcionalidad de URL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Button(
                      text: 'Perfil',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.profile);
                      },
                    ),
                  ),
                  const SizedBox(height: 20), // Espaciado entre secciones
                  // Texto "Soporte"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Soporte',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Botón "Sugerencias" con funcionalidad de URL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Button(
                      text: 'Atencion y contacto',
                      onPressed: () {
                        _launchUrl(
                            'https://www.banorte.com/wps/portal/ixe/Home/conoce-contacto/');
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Botón "Centro de ayuda" con funcionalidad de URL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Button(
                      text: 'Centro de ayuda',
                      onPressed: () {
                        _launchUrl(
                            'https://www.banorte.com/wps/portal/banorte/Home/ayuda/');
                      },
                    ),
                  ),
                  const SizedBox(height: 20), // Espaciado adicional
                  // Botón "Cerrar Sesión"
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    child: CustomButton(
                      text: 'Cerrar Sesión',
                      onPressed:
                          _logout, // Llamamos al método para cerrar sesión
                      // Aplica el estilo en el child del botón
                      child: Text(
                        'Cerrar Sesión',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Texto "Términos" con funcionalidad de URL
                  GestureDetector(
                    onTap: () {
                      _launchUrl(
                          'https://www.banorte.com/wps/portal/banorte/Home/servicios-en-linea/banca-digital/banco-linea/terminos-condiciones/');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Términos',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Texto "Política de Privacidad" con funcionalidad de URL
                  GestureDetector(
                    onTap: () {
                      _launchUrl(
                          'https://www.banorte.com/wps/portal/gfb/Home/banorte-te-informa/aviso-de-privacidad');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Política de Privacidad',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Padding extra debajo
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        onTabSelected: _onItemTapped, // Función para manejar las selecciones
        selectedIndex: _selectedIndex, // Perfil está seleccionada
      ),
    );
  }
}
