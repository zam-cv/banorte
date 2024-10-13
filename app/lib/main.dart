import 'package:flutter/material.dart';
import 'package:app/routes/app_routes.dart';
//import 'package:window_manager/window_manager.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await windowManager.ensureInitialized();

//   windowManager.waitUntilReadyToShow().then((_) async {
//     await windowManager.setTitleBarStyle(TitleBarStyle.hidden,
//         windowButtonVisibility: true);
//     await windowManager.show();
//   });

//   runApp(const MyApp());
// }

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
        fontFamily: 'NotoSans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.dark,
          primary: const Color(0xffec1c2d),
          onPrimary: Colors.black,
          secondary: Colors.grey,
          onSecondary: Colors.white,
          primaryContainer: const Color(0xff070d2a),
          onPrimaryContainer: const Color.fromARGB(255, 224, 224, 224),
          secondaryContainer: const Color.fromARGB(255, 17, 31, 85),
          onSecondaryContainer: const Color.fromARGB(255, 105, 105, 105),
          surface: Colors.grey,
          error: Colors.red,
          onError: Colors.white,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
