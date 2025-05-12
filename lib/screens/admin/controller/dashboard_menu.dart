
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../child/home/home_screen_2.dart';
import '../child/user/user_list/user_list.dart';


class MenuControllerScreen extends GetxController {
  // Índice de la pantalla actual
  var currentIndex = 1.obs;

  // Lista de pantallas disponibles
  final List<Widget> screens = [
    HomeScreen(),//0
    UserList()
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

