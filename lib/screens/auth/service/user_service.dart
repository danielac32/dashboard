
import 'dart:convert';
import 'dart:io';
import 'package:core_system/infrastructure/shared/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/constants.dart';
import '../../../infrastructure/entities/user_response.dart';


import '../../../infrastructure/shared/alert.dart';
import '../../../infrastructure/shared/handle_exceptions.dart';
import '../../../infrastructure/shared/handle_response.dart';
import 'dart:async';





class ApiService {
  static final String _baseUrl = AppStrings.urlApi;


  // Método genérico para POST
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/$endpoint');

    /*try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

     // return _handleResponse(response);
      return Handle.Response(response);
    } catch (e) {
      throw e;//throw Exception('Error de red: $e');
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
      final response = await http.get(url);
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

class AuthService {
  static Future<Autogenerated> login(String email, String password) async {
    try {
      final response = await ApiService.post(
        'auth/login',
        {
          'email': email,
          'password': password,
        },
      );
      // response ya es un Map<String, dynamic> (ApiService lo decodifica)
      return Autogenerated.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  Future<void> logout() async {
     LocalStorage.clear();
  }
}