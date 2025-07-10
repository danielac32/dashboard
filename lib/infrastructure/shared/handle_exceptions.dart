

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../screens/auth/controller/login_controller.dart';
import 'alert.dart';

/*
class ErrorExceptions {
  static Future<T> handleRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on http.ClientException catch (e) {
      Get.find<LoginController>().logout();
      _showError('Error de conexión: ${e.message}');
      throw Exception('Error de conexión: ${e.message}');
    } on SocketException catch (e) {
      Get.find<LoginController>().logout();
      _showError('No hay conexión a internet');
      throw Exception('Sin conexión: ${e.message}');
    } on Exception catch (_) {
      Get.find<LoginController>().logout();
      _showError('Tiempo de espera agotado');
      throw Exception('Timeout La solicitud tardó demasiado');
    } catch (e) {
      Get.find<LoginController>().logout();
      _showError('Error inesperado');
      throw Exception('Error: ${e.toString()}');
    }finally{

    }
  }
  static void _showError(String message) {
    SnackbarAlert.error(title: "Oops!", message: message, durationSeconds: 5);
  }
}*/


class ErrorExceptions {
  static Future<T> handleRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on http.ClientException catch (e) {
      return _handleError(
        error: e,
        errorMessage: 'Error de conexión: ${e.message}',
        snackbarMessage: 'Error de conexión: ${e.message}',
      );
    } on SocketException catch (e) {
      return _handleError(
        error: e,
        errorMessage: 'Sin conexión: ${e.message}',
        snackbarMessage: 'No hay conexión a internet',
      );
    } on Exception catch (_) {
      return _handleError(
        error: Exception('Timeout'),
        errorMessage: 'Timeout La solicitud tardó demasiado',
        snackbarMessage: 'Tiempo de espera agotado',
      );
    } catch (e) {
      return _handleError(
        error: e,
        errorMessage: 'Error: ${e.toString()}',
        snackbarMessage: 'Error inesperado',
      );
    }
  }

  static Future<T> _handleError<T>({
    required Object error,
    required String errorMessage,
    required String snackbarMessage,
  }) async {
    Get.find<LoginController>().logout();
    _showError(snackbarMessage);
    throw Exception(errorMessage);
  }

  static void _showError(String message) {
    SnackbarAlert.error(title: "Oops!", message: message, durationSeconds: 1);
  }
}


