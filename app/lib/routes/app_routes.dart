import 'package:flutter/material.dart';

// Importa las pantallas
import 'package:app/screens/learn.dart';
import 'package:app/screens/login.dart';
import 'package:app/screens/signup.dart';
import 'package:app/screens/forgot_password.dart';
import 'package:app/screens/home.dart';
import 'package:app/screens/practice.dart';
import 'package:app/screens/news.dart';
import 'package:app/screens/profile.dart';
import 'package:app/screens/splash_screen.dart'; // Importa la pantalla de splash
import 'package:app/screens/settings.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 0,
          ),
          child: child,
        ),
      ),
    );
  }
}

MaterialPageRoute<dynamic> page(RouteSettings settings, Widget child) {
  return MaterialPageRoute(
    settings: settings,
    builder: (context) => BaseLayout(child: child),
  );
}

class AppRoutes {
  // Rutas de la app
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String learn = '/learn';
  static const String practice = '/practice';
  static const String news = '/news';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static final Map<String, Widget> routes = {
    splash: const SplashScreen(), // SplashScreen como ruta predeterminada
    login: const Login(),
    signup: const Signup(),
    forgotPassword: const ForgotPassword(),
    home: const Home(),
    learn: const LearnPage(),
    practice: const PracticePage(),
    news: const NewsPage(),
    profile: const ProfilePage(),
    settings: const SettingsPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = routes[settings.name];

    if (builder != null) {
      return page(settings, builder);
    }

    // default route será el SplashScreen
    return page(settings, const SplashScreen());
  }
}
