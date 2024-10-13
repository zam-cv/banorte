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
      onTap: (int index) {
        onTabSelected(index);

        // Navegación según el ícono seleccionado
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/news'); // Navegar a la pantalla News
            break;
          case 2:
            Navigator.pushNamed(
                context, '/learn'); // Navegar a la pantalla Learn
            break;
          case 3:
            Navigator.pushNamed(
                context, '/practice'); // Navegar a la pantalla Practice
            break;
          case 4:
            // Navegar a la pantalla Profile (CAMBIAR)
            break;
        }
      },
      selectedItemColor: const Color(0xFFEC1C2D),
      unselectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: Offset(0, 8),
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
            offset: Offset(0, 8),
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
            offset: Offset(0, 8),
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
            offset: Offset(0, 8),
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
            offset: Offset(0, 8),
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
