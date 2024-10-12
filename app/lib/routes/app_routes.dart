import 'package:flutter/material.dart';

// Auth
import 'package:app/screens/login.dart';
import 'package:app/screens/signup.dart';
import 'package:app/screens/forgot_password.dart';
import 'package:app/screens/home.dart';

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
            // left: 16.0,
            // right: 16.0,
            // bottom: 16.0,
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

  static final Map<String, Widget> routes = {
    login: const Login(),
    signup: const Signup(),
    forgotPassword: const ForgotPassword(),
    home: const Home(),
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
