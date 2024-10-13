import 'package:flutter/material.dart';

class Degraded extends StatelessWidget {
  const Degraded({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      // Ocupa toda la pantalla
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.primaryContainer,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
    );
  }
}
