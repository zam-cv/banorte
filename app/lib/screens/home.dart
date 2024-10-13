import 'package:flutter/material.dart';
import '../widgets/custom_nav.dart'; // Asegúrate de importar el archivo donde creaste el CustomNavBar
import '../widgets/header_home.dart'; // Asegúrate de importar el archivo donde creaste el HeaderHome
import '../widgets/custom_sphere_widget.dart'; // Asegúrate de importar el archivo donde creaste el CustomSphereWidget

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Agregamos el HeaderHome en la parte superior del cuerpo
            HeaderHome(
              number: _selectedIndex +
                  1, // Ejemplo: pasamos el número que deseas mostrar
            ),
            const SizedBox(
                height: 20), // Espacio entre el header y el contenido principal

            // Texto principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aprende y mejora tu salud financiera',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 20), // Espacio entre texto y esferas

                  // Esferas con íconos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomSphereWidget(
                        icon: Icons.account_balance,
                        label: 'Seguridad',
                        backgroundColor: const Color(0xFFFFA400),
                        title: 'Seguridad',
                        description:
                            'Asegurar la cobertura de las necesidades financieras básicas, garantizando estabilidad y protegiendo los recursos esenciales en el presente.',
                      ),
                      CustomSphereWidget(
                        icon: Icons.attach_money,
                        label: 'Resilencia',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        title: 'Resilencia',
                        description:
                            'Capacidad de absorber y sobreponerse ante impactos financieros inesperados, manteniendo la estabilidad económica en tiempos de incertidumbre.',
                      ),
                      CustomSphereWidget(
                        icon: Icons.school,
                        label: 'Control',
                        backgroundColor: const Color(0xFFA81D3F),
                        title: 'Control',
                        description:
                            'Garantizar la gestión eficaz de los recursos financieros, proporcionando confianza y certidumbre en las decisiones económicas tanto presentes como futuras.',
                      ),
                      CustomSphereWidget(
                        icon: Icons.trending_up,
                        label: 'Libertad',
                        backgroundColor: const Color(0xFFFF671B),
                        title: 'Libertad',
                        description:
                            'Cumplir metas y objetivos financieros a largo plazo, logrando independencia económica y satisfacción en la planificación para el futuro.',
                      ),
                    ],
                  ),

                  const SizedBox(
                      height:
                          40), // Espacio entre las esferas y la siguiente sección

                  // Sección Aprende (contenedor con fondo oscuro)
                  buildSectionContainer(
                    context,
                    title: 'Aprende...',
                    description:
                        'Sobre conceptos básicos y otros temas que te ayudarán en tu vida financiera.',
                  ),

                  const SizedBox(height: 40), // Espacio entre las secciones

                  // Sección Practica (contenedor con fondo oscuro)
                  buildSectionContainer(
                    context,
                    title: 'Practica...',
                    description:
                        'Con ejemplos más reales y utiliza los conocimientos que has adquirido para mejorar tus habilidades financieras.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        onTabSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }

  // Método para crear los contenedores con fondo oscuro
  Widget buildSectionContainer(BuildContext context,
      {required String title, required String description}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
