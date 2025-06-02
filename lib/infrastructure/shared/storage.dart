import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/user_response.dart';


import 'package:get_storage/get_storage.dart';
import '../entities/user_response.dart';

class LocalStorage {
  static final box = GetStorage(); // Instancia única del almacenamiento

  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _status = 'user_status';

  // Guardar el estado (bool)
  static void saveStatus(bool status) {
    box.write(_status, status);
  }

  // Leer el estado (bool?)
  static bool? getStatus() {
    return box.read<bool>(_status);
  }

  // Guardar el token (String)
  static void saveToken(String token) {
    box.write(_keyToken, token);
  }

  // Obtener el token (String?)
  static String? getToken() {
    return box.read<String>(_keyToken);
  }

  // Guardar los datos del usuario (User)
  static void saveUser(User user) {
    box.write(_keyUser, jsonEncode(user.toJson()));
  }

  // Obtener los datos del usuario (User?)
  static User? getUser() {
    final userData = box.read<String>(_keyUser);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Limpiar todo el almacenamiento
  static void clear() {
    box.remove(_keyToken);
    box.remove(_keyUser);
    box.remove(_status);
    // o puedes usar box.erase(); para borrar todo
  }
}

/*
class LocalStorage {
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _status = 'user_status';


  static Future<void> saveStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_status, status);
  }

  static Future<bool?> getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_status);
  }

  // Guardar el token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Obtener el token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Guardar los datos del usuario
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  // Obtener los datos del usuario
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_keyUser);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Limpiar el almacenamiento (logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}*/


