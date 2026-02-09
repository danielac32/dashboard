

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core_system/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

import '../../../../../infrastructure/shared/alert.dart';
import '../../../../../infrastructure/shared/handle_exceptions.dart';
import '../../../../../infrastructure/shared/handle_response.dart';


class ServicePlanificacion {
  static final String _baseUrl = AppStrings.urlApiSigecof;


  static void _showError(String message) {
    SnackbarAlert.error(title: "Oops!", message: message, durationSeconds: 5);
  }

  static Future<Map<String, String>> _getHeaders() async {
    /* final token = await LocalStorage.getToken();
    if (token == null) {
      throw Exception('No se encontró un token de autenticación');
    }*/
    return {
      // 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }


  static Future<dynamic> post(
      String endpoint,
      Map<String, dynamic> body, {
        Map<String, String>? queryParams,
      }) async {
    final url = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParams);

    /*try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );
      return Handle.Response(response); //return _handleResponse(response);
    } catch (e) {
      throw e;// throw Exception('Error de red: $e');
    }*/
    return await ErrorExceptions.handleRequest(() async {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );//.timeout(const Duration(seconds: 30));
      return Handle.Response(response);
    });
  }

  // Método genérico para GET
  static Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    final url = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParams);

    /*try {
      final response = await http.get(
        url,
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      print("error aqui");
      throw Exception('Error de red: $e');
    }*/
    return await ErrorExceptions.handleRequest(() async {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      return Handle.Response(response);
    });
  }

  // Manejar la respuesta
  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200: // OK
      case 201: // Created
      case 204: // No Content (para DELETE)
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad Request: ${response.body}');
      case 401:
      case 403:
        throw Exception('No autorizado: ${response.body}');
      case 404:
        throw Exception('Recurso no encontrado');
      case 500:
        throw Exception('Error del servidor: ${response.body}');
      default:
        throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }


  /*************************************************************************/

  static Future<void> downloadFile(
      String endpoint,
      String fileName, {
        Map<String, String>? queryParams,
      }) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParams);

      print('🔗 URL de descarga: $url');

      // Hacer la petición GET para obtener el archivo
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      // Verificar si la respuesta fue exitosa
      if (response.statusCode == 200) {
        // Crear un blob con los datos del archivo
        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        // Crear un elemento <a> para la descarga
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();

        // Liberar el objeto URL
        html.Url.revokeObjectUrl(url);

        print('✅ Archivo descargado: $fileName');
      } else {
        throw Exception('Error en la descarga: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('❌ Error al descargar archivo: $e');
      rethrow;
    }
  }

  // Método específico para descargar reporte Excel
  static Future<void> downloadExcelReport({
    required String url,
    required String startDate,
    required String endDate,
    required String fileName,
  }) async {
    try {

      // Parámetros de consulta
      final queryParams = {
        'desde': startDate,
        'hasta': endDate,
      };

      // Llamar al método de descarga
      await downloadFile(
        url, // Asegúrate que este endpoint coincide con tu backend
        fileName,
        queryParams: queryParams,
      );

    } catch (e) {
      print('❌ Error en downloadExcelReport: $e');
      rethrow;
    }
  }

}
