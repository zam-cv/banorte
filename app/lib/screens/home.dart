import 'package:flutter/material.dart';
import '../widgets/custom_nav.dart'; // Asegúrate de importar el archivo donde creaste el CustomNavBar

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
      appBar: AppBar(
        title: const Text('Banorte AI'),
      ),
      body: Center(
        child: Text('Selected Tab: $_selectedIndex'),
      ),
      bottomNavigationBar: CustomNavBar(
        onTabSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
