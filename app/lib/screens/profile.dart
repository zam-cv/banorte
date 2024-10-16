import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_nav.dart'; // Asegúrate de importar la navbar existente
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  String firstName = '';
  String lastName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    getUserInfo(); // Llama al método para obtener la información del usuario cuando se inicia la pantalla
  }

  // Método para obtener la información del usuario desde el backend
  Future<void> getUserInfo() async {
    final response = await http.get(
      Uri.parse(
          '${Config.baseUrl}/api/auth/user-info'), // Cambia la URL si es necesario
      headers: {
        'Authorization': 'Bearer ${Config.token}', // Token para autenticación
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        firstName = data['user']['first_name']; // Obtén el nombre
        lastName = data['user']['last_name']; // Obtén el apellido
        email = data['user']['email']; // Obtén el correo
      });
    } else {
      // Manejo de errores si la solicitud falla
      print(
          'Error al obtener la información del usuario: ${response.statusCode}');
    }
  }

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
            color: Theme.of(context)
                .colorScheme
                .secondary, // Fondo azul para el logo
            padding: const EdgeInsets.only(
              top: 40, // Aumenta la distancia del logo desde la parte superior
              bottom: 20, // Espacio debajo del logo
            ),
            child: SvgPicture.asset(
              'assets/logo.svg', // Logo en SVG
              height: 30,
              colorFilter: ColorFilter.mode(
                Theme.of(context)
                    .colorScheme
                    .primary, // Color principal del logo
                BlendMode.srcIn,
              ),
            ),
          ),
          // Texto "Mi perfil" separado del fondo azul
          const SizedBox(height: 30), // Espaciado entre el AppBar y "Mi perfil"
          Text(
            'Mi perfil', // Título de la página
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Cambiado a primary
                ),
          ),
          // Contenido del perfil
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Avatar con borde rojo y separación adicional
                  const SizedBox(
                      height: 30), // Espacio extra para centrar avatar
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red, // Borde rojo
                        width: 5,
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(0.0), // Añade un padding extra
                      child: ClipOval(
                        child: SvgPicture.asset(
                          'assets/user.svg', // Ícono de usuario
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Nombre y correo electrónico dinámico
                  Text(
                    '$firstName $lastName',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Cambiado a primary
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary, // Cambiado a tertiary
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Mi racha semanal
                  buildStreakTile(
                    context,
                    'Mi racha semanal',
                    '0/7',
                    'assets/fire.svg',
                  ),
                  const SizedBox(height: 20),
                  // Mi racha de semanas
                  buildStreakTile(
                    context,
                    'Mi racha de semanas',
                    '12',
                    'assets/fire.svg',
                  ),
                  const Spacer(),
                  // Botón de editar datos
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción para editar datos
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Editar datos',
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
