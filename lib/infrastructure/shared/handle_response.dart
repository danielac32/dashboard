

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'alert.dart';

class Handle {
  static dynamic Response(http.Response response) {
    final dynamic jsonResponse = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      // Éxito: retornar los datos tal cual
        return jsonResponse;

      case 400:
        final String errorMessage = jsonResponse?['error'] ?? 'Solicitud inválida. Verifica los datos enviados.';
        SnackbarAlert.error(
          title: "Error 400 - Solicitud Incorrecta",
          message: errorMessage,
          durationSeconds: 5,
        );
        throw Exception('400 Bad Request: $errorMessage');

      case 401:
        final String errorMessage401 = jsonResponse?['error'] ?? 'No estás autenticado. Inicia sesión nuevamente.';
        SnackbarAlert.error(
          title: "Error 401 - No Autorizado",
          message: errorMessage401,
          durationSeconds: 5,
        );
        throw Exception('401 Unauthorized: $errorMessage401');

      case 403:
        final String errorMessage403 = jsonResponse?['error'] ?? 'No tienes permisos para acceder a este recurso.';
        SnackbarAlert.error(
          title: "Error 403 - Prohibido",
          message: errorMessage403,
          durationSeconds: 5,
        );
        throw Exception('403 Forbidden: $errorMessage403');

      case 404:
        final String errorMessage404 = jsonResponse?['error'] ?? 'El recurso solicitado no fue encontrado.';
        SnackbarAlert.error(
          title: "Error 404 - No Encontrado",
          message: errorMessage404,
          durationSeconds: 5,
        );
        throw Exception('404 Not Found: $errorMessage404');

      case 500:
        final String errorMessage500 = jsonResponse?['error'] ?? 'Ocurrió un error interno en el servidor. Intenta más tarde.';
        SnackbarAlert.error(
          title: "Error 500 - Error Interno del Servidor",
          message: errorMessage500,
          durationSeconds: 5,
        );
        throw Exception('500 Internal Server Error: $errorMessage500');

      default:
        final String genericMessage = 'Código de estado inesperado: ${response.statusCode}';
        final String userMessage = jsonResponse?['error'] != null
            ? jsonResponse['error']
            : 'Ocurrió un error desconocido. Por favor, intenta nuevamente o contacta al soporte.';

        SnackbarAlert.error(
          title: "Error",
          message: userMessage,
          durationSeconds: 5,
        );
        throw Exception('$genericMessage - Detalle: $userMessage');
    }
  }
}

