import 'package:flutter/material.dart';
import '../widgets/custom_nav.dart'; // Asegúrate de importar el archivo donde creaste el CustomNavBar
import '../widgets/header_home.dart'; // Asegúrate de importar el archivo donde creaste el HeaderHome

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Aquí puedes agregar lógica para navegar o cambiar de contenido dependiendo del índice seleccionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Agregamos el HeaderHome en la parte superior del cuerpo
          HeaderHome(
            number: _selectedIndex +
                1, // Ejemplo: pasamos el número que deseas mostrar
          ),
          const SizedBox(
              height: 20), // Espacio entre el header y el contenido principal
          Expanded(
            child: Center(
              child: Text('Selected Tab: $_selectedIndex'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        onTabSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
