import 'package:flutter/material.dart';

// Importa la pantalla learn
import 'package:app/screens/learn.dart';

// Auth
import 'package:app/screens/login.dart';
import 'package:app/screens/signup.dart';
import 'package:app/screens/forgot_password.dart';
import 'package:app/screens/home.dart';
import 'package:app/screens/practice.dart';
import 'package:app/screens/news.dart';
import 'package:app/screens/profile.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 25.0,
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
  // Auth
  static const String login = '/';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String learn = '/learn';
  static const String practice = '/practice';
  static const String news = '/news';
  static const String profile = '/profile';

  static final Map<String, Widget> routes = {
    login: const Login(),
    signup: const Signup(),
    forgotPassword: const ForgotPassword(),
    home: const Home(),
    learn: const LearnPage(),
    practice: const PracticePage(),
    news: const NewsPage(),
    profile: const ProfilePage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = routes[settings.name];

    if (builder != null) {
      return page(settings, builder);
    }

    // default route
    return page(settings, const Login());
  }
}
