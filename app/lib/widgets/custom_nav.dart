import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const CustomNavBar({
    Key? key,
    required this.onTabSelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF070D2A), // Fondo oscuro
      currentIndex: selectedIndex,
      onTap: onTabSelected,
      selectedItemColor:
          const Color(0xFFEC1C2D), // Color para ícono seleccionado
      unselectedItemColor: Colors.white, // Color para íconos no seleccionados
      items: [
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: Offset(0, 8), // Baja el ícono 6 píxeles
            child: Image.asset(
              'assets/home_icon.png',
              width: 36,
              height: 36,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: Offset(0, 8), // Baja el ícono 6 píxeles
            child: Image.asset(
              'assets/news_icon.png',
              width: 36,
              height: 36,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: Offset(0, 8), // Baja el ícono 6 píxeles
            child: Image.asset(
              'assets/learn_icon.png',
              width: 36,
              height: 36,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: Offset(0, 8), // Baja el ícono 6 píxeles
            child: Image.asset(
              'assets/practice_icon.png',
              width: 36,
              height: 36,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: Offset(0, 8), // Baja el ícono 6 píxeles
            child: Image.asset(
              'assets/settings_icon.png',
              width: 36,
              height: 36,
            ),
          ),
          label: '',
        ),
      ],
      type: BottomNavigationBarType
          .fixed, // Mantiene el tamaño fijo de los íconos
    );
  }
}
