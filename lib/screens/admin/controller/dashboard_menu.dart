
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../child/home/home_screen_2.dart';
import '../child/user/register/user_register.dart';
import '../child/user/user_list/user_list.dart';
import '../constant/enum_screen.dart';
import '../widget/media/media_screen.dart';




class MenuControllerScreen extends GetxController {
  // Índice de la pantalla actual
  /*var currentIndex = 1.obs;

  // Lista de pantallas disponibles
  final List<Widget> screens = [
    HomeScreen(),//0
    UserList(),//1
    UserRegister(),//2

  ];

  // Método para cambiar la pantalla actual
  void changeScreen(int index) {
    currentIndex.value = index;
  }
*/

  var currentScreen = AppScreen.mediaScreen.obs;
  final Map<AppScreen, Widget> screenMap = {
    AppScreen.home: HomeScreen(),
    AppScreen.userList: UserList(),
    AppScreen.userRegister: UserRegister(),
    AppScreen.mediaScreen: MediaScreen()
  };

  // Cambia la pantalla de forma segura
  void goToScreen(AppScreen screen) {
    if (screenMap.containsKey(screen)) {
      currentScreen.value = screen;
    } else {
      throw Exception("Screen not found in screen map: $screen");
    }
  }
  // Retorna el widget actual según el screen seleccionado
  Widget get currentView => screenMap[currentScreen.value]!;
}

