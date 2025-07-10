

import 'dart:convert';

import 'package:core_system/core/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../../../../../infrastructure/shared/handle_exceptions.dart';
import '../../../../../infrastructure/shared/handle_response.dart';


class ServiceEgreso {
  static final String _baseUrl = AppStrings.urlApiSigecof;

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
      return Handle.Response(response);//return _handleResponse(response);
    } catch (e) {
      throw e;//
      //throw Exception('Error de red: $e');
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
      return Handle.Response(response);//return _handleResponse(response);
    } catch (e) {
      throw e;//throw Exception('Error de red: $e');
    }*/
    return await ErrorExceptions.handleRequest(() async {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );//.timeout(const Duration(seconds: 30));

      return Handle.Response(response);
    });
  }
}
