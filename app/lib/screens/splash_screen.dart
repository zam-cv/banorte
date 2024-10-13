import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/storage.dart';
import 'package:app/config.dart';
import 'package:app/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializamos el AnimationController para la animación de opacidad
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Definimos la animación de opacidad (fade-in)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Ejecutar la animación
    _controller.forward();

    // Verificamos el token antes de decidir hacia dónde navegar
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    // Leer el token desde el almacenamiento seguro
    String? token = await Storage.read('token');
    Config.token = token; // Guardamos el token en la configuración global

    bool isValidToken = false;
    if (Config.token != null) {
      // Verificar si el token es válido
      isValidToken = await AuthService.verifyToken();
    }

    // Después de verificar, navega a la ruta correspondiente
    if (isValidToken) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo de Banorte
              SvgPicture.asset(
                'assets/logo.svg',
                height: 35,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 20),
              // Texto "El banco fuerte de México"
              Text(
                'El banco fuerte de México',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
