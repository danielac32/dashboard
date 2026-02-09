

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core_system/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

import '../../../../../infrastructure/shared/alert.dart';
import '../../../../../infrastructure/shared/handle_exceptions.dart';
import '../../../../../infrastructure/shared/handle_response.dart';
import '../../../../infrastructure/shared/storage.dart';


class  DgticService{
  static final String _baseUrl = AppStrings.  urlApiSigecof;



  static Future<Map<String, String>> _getHeaders() async {
    final token = LocalStorage.getToken();
    if (token == null) {
      throw Exception('No se encontró un token de autenticación');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }







  static Future<dynamic> delete(String endpoint, {Map<String, String>? queryParams}) async {
    final url = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParams);

    return await ErrorExceptions.handleRequest(() async {
      final response = await http.delete(
        url,
        headers: await _getHeaders(),//{'Content-Type': 'application/json'},
      );//.timeout(const Duration(seconds: 30));
      return Handle.Response(response);
    });
  }

  static Future<dynamic> upload2(String endpoint, {required Map<String, Map<String, Object>> body}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    return await ErrorExceptions.handleRequest(() async {
      final response = await http.post(
        url,
        headers: await _getHeaders(),//{'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );//.timeout(const Duration(seconds: 30));
      return Handle.Response(response);
    });
  }

  static Future<dynamic> upload(String endpoint, {required Map<String, dynamic> body}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    return await ErrorExceptions.handleRequest(() async {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );
      return Handle.Response(response);
    });
  }

  static Future<dynamic> post(
      String endpoint,
      Map<String, dynamic> body, {
        Map<String, String>? queryParams,
      }) async {
    final url = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParams);

    return await ErrorExceptions.handleRequest(() async {
      final response = await http.post(
        url,
        headers: await _getHeaders(),//{'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );//.timeout(const Duration(seconds: 30));
      return Handle.Response(response);
    });
  }


  // Método genérico para GET
  static Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    final url = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParams);

    return await ErrorExceptions.handleRequest(() async {
      final response = await http.get(
        url,
        headers: await _getHeaders(),//{'Content-Type': 'application/json'},
      );//.timeout(const Duration(seconds: 30));

      return Handle.Response(response);
    });
  }




  static Future<void> downloadFile(
      String endpoint,
      String fileName, {
        Map<String, String>? queryParams,
      }) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParams);

      print('🔗 URL de descarga: $url');

      // Hacer la petición GET para obtener el archivo
      final response = await http.get(
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
    required String startDate,
    required String endDate, required String fileName,
  }) async {
    try {
      // Generar nombre del archivo
      final now = DateTime.now();
      final fileName = 'Reporte_Soportes_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour}${now.minute}${now.second}.xlsx';

      // Parámetros de consulta
      final queryParams = {
        'startDate': startDate,
        'endDate': endDate,
      };

      // Llamar al método de descarga
      await downloadFile(
        'api/soporte/excel-report', // Asegúrate que este endpoint coincide con tu backend
        fileName,
        queryParams: queryParams,
      );

    } catch (e) {
      print('❌ Error en downloadExcelReport: $e');
      rethrow;
    }
  }
  
}
