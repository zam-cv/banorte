import 'package:flutter/material.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/storage.dart';
import 'package:app/config.dart';
import 'package:app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Leer el token almacenado al iniciar la app
  String? token = await Storage.read('token');
  Config.token = token; // Guardamos el token en la configuración global

  print("Token leído desde el almacenamiento: $token");

  // Verificar si el token es válido
  bool isValidToken = false;
  if (Config.token != null) {
    print("Verificando token...");
    isValidToken = await AuthService.verifyToken();
    print("¿Es el token válido?: $isValidToken");
  }

  // Inicializar la app
  runApp(MyApp(isValidToken: isValidToken));
}

class MyApp extends StatelessWidget {
  final bool isValidToken;

  const MyApp({super.key, required this.isValidToken});

  @override
  Widget build(BuildContext context) {
    print("Token es válido al iniciar la app: $isValidToken");

    return MaterialApp(
      title: 'Banorte AI',
      theme: ThemeData(
        fontFamily: 'Roboto',
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
          tertiary: const Color(0xff5b6670),
          primaryContainer: const Color(0x52131B44),
          onPrimaryContainer: const Color.fromARGB(255, 224, 224, 224),
          secondaryContainer: const Color.fromARGB(255, 17, 31, 85),
          onSecondaryContainer: const Color.fromARGB(255, 105, 105, 105),
          surface: Color.fromARGB(255, 255, 255, 255),
          error: Colors.red,
          onError: Colors.white,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // Usamos la variable isValidToken para definir la ruta inicial
      initialRoute: isValidToken ? AppRoutes.home : AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
