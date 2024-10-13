import 'package:flutter/material.dart';
import 'package:app/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banorte AI',
      theme: ThemeData(
        fontFamily: 'Roboto', // Fuente por defecto de la app
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: 'Gotham', fontWeight: FontWeight.w900, fontSize: 30),
          displayMedium: TextStyle(
              fontFamily: 'Gotham', fontWeight: FontWeight.w700, fontSize: 25),
          bodyLarge: TextStyle(
              fontFamily: 'Roboto', fontWeight: FontWeight.w400, fontSize: 17),
          bodyMedium: TextStyle(
              fontFamily: 'Roboto', fontWeight: FontWeight.w300, fontSize: 12),
          labelLarge: TextStyle(
              fontFamily: 'Gotham', fontWeight: FontWeight.w700, fontSize: 15),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.dark,
          primary: const Color(0xffeb0029),
          onPrimary: Colors.black,
          secondary: Colors.white,
          onSecondary: Colors.white,
          primaryContainer: const Color(0x84131b44),
          onPrimaryContainer: const Color.fromARGB(255, 224, 224, 224),
          secondaryContainer: const Color.fromARGB(255, 17, 31, 85),
          onSecondaryContainer: const Color.fromARGB(255, 105, 105, 105),
          surface: Color.fromARGB(255, 216, 215, 215),
          error: Colors.red,
          onError: Colors.white,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
