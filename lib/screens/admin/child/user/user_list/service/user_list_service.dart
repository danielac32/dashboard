


import 'dart:convert';

import 'package:core_system/core/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../../../../../../infrastructure/shared/handle_exceptions.dart';
import '../../../../../../infrastructure/shared/handle_response.dart';
import '../../../../../../infrastructure/shared/storage.dart';

class UserListService {
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
    /*try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );
      return Handle.Response(response);//return _handleResponse(response);
    } catch (e) {
      throw e;//throw Exception('Error de red: $e');
    }*/
    return await ErrorExceptions.handleRequest(() async {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));
      return Handle.Response(response);
    });
  }

  static Future<dynamic> update(String endpoint, {required int id, required Map<String, dynamic> data}) async {
    final url = Uri.parse('$_baseUrl/$endpoint/$id'); // Construye la URL con el ID
    //print('url $url');
    /*try {
      final response = await http.patch(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data), // Codifica los datos en JSON
      );
      return Handle.Response(response);//return _handleResponse(response); // Maneja la respuesta
    } catch (e) {
      throw e;//throw Exception('Error de red: $e');
    }*/

    return await ErrorExceptions.handleRequest(() async {
      final response = await http.patch(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));
      return Handle.Response(response);
    });
  }

  static Future<dynamic> delete(String endpoint, {required int id}) async {
    final url = Uri.parse('$_baseUrl/$endpoint/$id');

    /*try {
      // Realizar la solicitud DELETE con el token en los encabezados
      final response = await http.delete(
        url,
        headers: await _getHeaders(),
      );
      return Handle.Response(response);//return _handleResponse(response); // Manejar la respuesta
    } catch (e) {
      throw e;//throw Exception('Error de red: $e');
    }*/
    return await ErrorExceptions.handleRequest(() async {
      final response = await http.delete(
        url,
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 30));
      return Handle.Response(response);
    });

  }



  static Future<dynamic> getFilterUser(String endpoint,String endpoint2, {
    Map<String, dynamic>? queryParams
  }) async {
    final url = Uri.parse('$_baseUrl/$endpoint/$endpoint2').replace(
      queryParameters: queryParams,
    );

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
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 30));
      return Handle.Response(response);
    });
  }


  static Future<dynamic> getUserPermissions(String endpoint,String endpoint2, {required int userId}) async {
    final url = Uri.parse('$_baseUrl/$endpoint/$userId/$endpoint2');

    /*try {
      final response = await http.get(
        url,
        headers: await _getHeaders(),
      );
      return Handle.Response(response);//return _handleResponse(response);
    } catch (e) {
      throw e;//throw Exception('Error al obtener permisos del usuario: $e');
    }*/
    return await ErrorExceptions.handleRequest(() async {
      final response = await http.get(
        url,
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 30));
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
      throw e;// throw Exception('Error de red: $e');
    }*/
    return await ErrorExceptions.handleRequest(() async {
      final response = await http.get(
        url,
        headers: await _getHeaders(),
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
}
