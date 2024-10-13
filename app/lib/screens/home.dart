import 'package:flutter/material.dart';
import '../widgets/custom_nav.dart'; // Asegúrate de importar el archivo donde creaste el CustomNavBar
import '../widgets/header_home.dart'; // Asegúrate de importar el archivo donde creaste el HeaderHome
import '../widgets/custom_sphere_widget.dart'; // Asegúrate de importar el archivo donde creaste el CustomSphereWidget
import '../widgets/chat.dart'; // Importa el nuevo componente del chat

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        HeaderHome(
                          number: _selectedIndex + 1,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aprende y mejora tu salud financiera',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 20),
                              // Esferas con íconos
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
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
                              const SizedBox(height: 40),
                              // Contenedor gris para la sección Aprende
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/learn_icon.png',
                                          height: 24,
                                          width: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Aprende...',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Sobre conceptos básicos y otros temas que te ayudarán en tu vida financiera.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              // Contenedor gris para la sección Practica
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/practice_icon.png',
                                          height: 24,
                                          width: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Practica...',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Con ejemplos más reales y utiliza los conocimientos que has adquirido para mejorar tus habilidades financieras.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(), // Para asegurar que el chat esté en la parte inferior
                      ],
                    ),
                  ),
                ),
              ),
              // Botón de Chat en la esquina inferior derecha
              const ChatButton(),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(
        onTabSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
