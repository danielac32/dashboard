




import 'dart:convert';

import 'package:core_system/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../../../../../infrastructure/shared/handle_response.dart';
import '../../../../../../infrastructure/shared/storage.dart';

class RegisterService {
  static final String _baseUrl = AppStrings.urlApi;


  static Future<Map<String, String>> _getHeaders() async {
    final token = await LocalStorage.getToken();
    if (token == null) {
      throw Exception('No se encontró un token de autenticación');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }


  // Método genérico para POST
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );
      return Handle.Response(response);//return _handleResponse(response);
    } catch (e) {
      throw e;//throw Exception('Error de red: $e');
    }
  }

  static Future<dynamic> update(String endpoint, {required int id, required Map<String, dynamic> data}) async {
    final url = Uri.parse('$_baseUrl/$endpoint/$id'); // Construye la URL con el ID
    //print('url $url');
    try {
      final response = await http.patch(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data), // Codifica los datos en JSON
      );
      return Handle.Response(response);//return _handleResponse(response); // Maneja la respuesta
    } catch (e) {
      throw e;//throw Exception('Error de red: $e');
    }
  }

  static Future<dynamic> delete(String endpoint, {required int id}) async {
    final url = Uri.parse('$_baseUrl/$endpoint/$id');

    try {
      // Realizar la solicitud DELETE con el token en los encabezados
      final response = await http.delete(
        url,
        headers: await _getHeaders(),
      );
      return Handle.Response(response);//return _handleResponse(response); // Manejar la respuesta
    } catch (e) {
      throw e;//throw Exception('Error de red: $e');
    }
  }



  static Future<dynamic> getFilterUser(String endpoint,String endpoint2, {
    Map<String, dynamic>? queryParams
  }) async {
    final url = Uri.parse('$_baseUrl/$endpoint/$endpoint2').replace(
      queryParameters: queryParams,
    );

    try {
      final response = await http.get(
        url,
        headers: await _getHeaders(),
      );
      return Handle.Response(response);//return _handleResponse(response);
    } catch (e) {
      throw e;//throw Exception('Error de red: $e');
    }
  }


  static Future<dynamic> getUserPermissions(String endpoint,String endpoint2, {required int userId}) async {
    final url = Uri.parse('$_baseUrl/$endpoint/$userId/$endpoint2');

    try {
      final response = await http.get(
        url,
        headers: await _getHeaders(),
      );
      return Handle.Response(response);//return _handleResponse(response);
    } catch (e) {
      throw e;//throw Exception('Error al obtener permisos del usuario: $e');
    }
  }

  // Método genérico para GET
  static Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    final url = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        url,
        headers: await _getHeaders(),
      );
      return Handle.Response(response);//return _handleResponse(response);
    } catch (e) {
      throw e;//throw Exception('Error de red: $e');
    }
  }

  // Manejar la respuesta
  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200: // OK
      case 201: // Created
      case 204: // No Content (para DELETE)
        return jsonDecode(response.body);

      case 400:
        Get.snackbar(
          'Error en la solicitud',
          'Datos incorrectos o incompletos',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        throw Exception('Bad Request: ${response.body}');

      case 401:
        Get.snackbar(
          'Sesión expirada',
          'Por favor inicie sesión nuevamente',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        throw Exception('No autorizado: ${response.body}');

      case 403:
        Get.snackbar(
          'Acceso denegado',
          'No tienes permisos para esta acción',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        throw Exception('Prohibido: ${response.body}');

      case 404:
        Get.snackbar(
          'No encontrado',
          'El recurso solicitado no existe',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        throw Exception('Recurso no encontrado');

      case 500:
        Get.snackbar(
          'Error del servidor',
          'Por favor intente más tarde',
          backgroundColor: Colors.red[800],
          colorText: Colors.white,
          duration: Duration(seconds: 4),
        );
        throw Exception('Error del servidor: ${response.body}');

      case 409:
        Get.snackbar(
          'Usuario existente',
          'El correo electrónico ya está registrado',
          backgroundColor: Colors.orange[800],
          colorText: Colors.white,
          icon: Icon(Icons.person_off, color: Colors.white),
        );
        throw Exception('El usuario ya existe: ${response.body}');

      default:
        Get.snackbar(
          'Error ${response.statusCode}',
          'Ocurrió un error inesperado',
          backgroundColor: Colors.grey[800],
          colorText: Colors.white,
        );
        throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }
}
