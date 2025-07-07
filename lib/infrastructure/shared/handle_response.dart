

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'alert.dart';

class Handle{
static dynamic Response(http.Response response){
  final dynamic jsonResponse = jsonDecode(response.body);
  switch (response.statusCode) {
    case 200:
      return jsonResponse;
    case 400:
      SnackbarAlert.error(title: "HTTP", message: jsonResponse?['error'], durationSeconds: 5);
      throw Exception('Bad Request');
    case 401:
    case 403:
      final errorMessage = (jsonResponse?['error']) as String;
      SnackbarAlert.error(title: "HTTP", message: jsonResponse?['error'], durationSeconds: 5);
      throw Exception(errorMessage);

    case 404:
      final errorMessage = (jsonResponse?['error']) as String;
      SnackbarAlert.error(title: "HTTP", message: jsonResponse?['error'], durationSeconds: 5);
      throw Exception(errorMessage);

    case 500:
      final errorMessage = (jsonResponse?['error']) as String;
      SnackbarAlert.error(title: "HTTP", message: jsonResponse?['error'], durationSeconds: 5);
      throw Exception(errorMessage);

    default:
      SnackbarAlert.error(title: "HTTP", message: 'Error en la solicitud', durationSeconds: 5);
      throw Exception('Error en la solicitud: ${response.statusCode}');
  }
}

}