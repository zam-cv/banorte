import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/config.dart';

class AuthService {
  // Método para hacer peticiones POST al backend
  static Future<http.Response> post(
      String url, Map<String, String> body, bool withAuth) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (withAuth && Config.token != null) {
      headers['Authorization'] = 'Bearer ${Config.token}';
    }

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    return response;
  }

  // Método para hacer una solicitud GET para verificar el inicio de sesión
  static Future<http.Response> verifySession() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Añadir el token de autorización
    if (Config.token != null) {
      headers['Authorization'] = 'Bearer ${Config.token}';
    }

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/auth/verify'),
      headers: headers,
    );

    return response;
  }
}
