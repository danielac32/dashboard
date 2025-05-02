
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../child/home/home_screen.dart';
import '../child/home/home_screen_4.dart';


class MenuControllerScreen extends GetxController {
  // Índice de la pantalla actual
  var currentIndex = 0.obs;

  // Lista de pantallas disponibles
  final List<Widget> screens = [
    HomeScreen()

    /*IndexScreen(),
    UsersScreen(),
    ContentScreen(),
    SettingsScreen(),
    ListUser(),
    RegisterScreen()*/
  ];


  // Método para cambiar la pantalla actual
  void changeScreen(int index) {
    currentIndex.value = index;
  }
}

