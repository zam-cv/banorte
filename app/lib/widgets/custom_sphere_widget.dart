import 'package:flutter/material.dart';

class CustomSphereWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final String title;
  final String description;

  const CustomSphereWidget({
    Key? key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPopUp(context);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: backgroundColor, // Color personalizado
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _showPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 200, // Establece la altura máxima del diálogo
            ),
            child: Stack(
              clipBehavior:
                  Clip.none, // Permite que el tache se salga del cuadro
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Esfera en el lado izquierdo
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: backgroundColor,
                            child: Icon(
                              icon,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Espacio entre la esfera y el texto
                          // Título en la misma línea
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Descripción debajo
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Posiciona el tache en la esquina superior derecha
                Positioned(
                  right: -0, // Sale un poco hacia afuera
                  top: -0, // Sale un poco hacia arriba
                  child: IconButton(
                    iconSize: 36,
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
