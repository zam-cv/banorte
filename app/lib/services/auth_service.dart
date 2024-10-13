import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/config.dart';
import 'package:app/storage.dart';

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

  // Método para verificar si el token es válido
  static Future<bool> verifyToken() async {
    Map<String, String> headers = {};

    if (Config.token != null) {
      headers['Authorization'] = 'Bearer ${Config.token}';
    }

    final response = await http.get(
      Uri.parse(
          '${Config.baseUrl}/api/auth/verify'), // Ruta para verificar el token
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true; // Token válido
    } else {
      // El token no es válido, lo eliminamos
      await Storage.delete('token');
      Config.token = null;
      return false; // Token inválido
    }
  }
}
