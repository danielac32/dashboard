

import 'dart:io';

import 'package:http/http.dart' as http;

import 'alert.dart';

class ErrorExceptions {
  static Future<T> handleRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on http.ClientException catch (e) {
      _showError('Error de conexión: ${e.message}');
      throw Exception('Error de conexión: ${e.message}');
    } on SocketException catch (e) {
      _showError('No hay conexión a internet');
      throw Exception('Sin conexión: ${e.message}');
    } on Exception catch (_) {
      _showError('Tiempo de espera agotado');
      throw Exception('Timeout La solicitud tardó demasiado');
    } catch (e) {
      _showError('Error inesperado');
      throw Exception('Error: ${e.toString()}');
    }
  }
  static void _showError(String message) {
    SnackbarAlert.error(title: "Oops!", message: message, durationSeconds: 5);
  }
}