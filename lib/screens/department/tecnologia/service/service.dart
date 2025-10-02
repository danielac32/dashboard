

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core_system/core/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../../../../../infrastructure/shared/alert.dart';
import '../../../../../infrastructure/shared/handle_exceptions.dart';
import '../../../../../infrastructure/shared/handle_response.dart';
import '../../../../infrastructure/shared/storage.dart';


class  XmlService{
  static final String _baseUrl = AppStrings.urlApiSigecof;



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
      ).timeout(const Duration(seconds: 30));

      return Handle.Response(response);
    });
  }
}
