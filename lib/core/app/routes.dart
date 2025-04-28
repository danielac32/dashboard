
import 'package:get/get.dart';

import '../../screens/admin/dashboard_admin.dart';
import '../../screens/auth/login.dart';
import '../../screens/user/dashboard_user.dart';

//import '../presentation/home/home_screen.dart';
//import '../presentation/reports/reports_screen.dart';

class AppRoutes {
  static const String login = '/login';
  //static const String register = '/register';
  static const String dashboardAdmin = '/admin';
  static const String dashboardUser = '/user';

  // Lista de rutas para GetPages
  static final List<GetPage> routes = [
    GetPage(name: login, page: () => LoginScreen()),
    //GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: dashboardAdmin, page: () => DashboardAdmin()),
    GetPage(name: dashboardUser, page: () => DashboardUser()),
  ];

  // Método para navegar a una ruta específica
  static Future<T?>? navigateTo<T>(String routeName, {dynamic arguments}) {
    return Get.toNamed<T>(routeName, arguments: arguments);
  }

  // Método para navegar y reemplazar la ruta actual
  static Future<T?>? navigateAndReplace<T>(String routeName, {dynamic arguments}) {
    return Get.offNamed<T>(routeName, arguments: arguments);
  }

  // Método para navegar y eliminar todas las rutas anteriores
  static Future<T?>? navigateAndRemoveUntil<T>(String routeName, {dynamic arguments}) {
    return Get.offAllNamed<T>(routeName, arguments: arguments);
  }
}


/*

1. Get.toNamed() → Ir a una nueva pantalla (como push)
Equivalente a: Navigator.pushNamed()

Qué hace: Abre una nueva pantalla sobre la actual (puedes volver atrás).

Ejemplo:

dart
Get.toNamed('/ruta'); // Navega a '/ruta'
2. Get.offNamed() → Reemplazar pantalla (como pushReplacement)
Equivalente a: Navigator.pushReplacementNamed()

Qué hace: Cierra la pantalla actual y abre una nueva (no puedes volver atrás con el botón físico).

Ejemplo (útil en login → home):

dart
Get.offNamed('/home'); // Reemplaza la pantalla actual por '/home'
3. Get.offAllNamed() → Ir a una pantalla y cerrar todas las anteriores (como pushAndRemoveUntil)
Equivalente a: Navigator.pushNamedAndRemoveUntil()

Qué hace: Cierra todas las pantallas en la pila y abre una nueva.

Ejemplo (útil para cerrar sesión):

dart
Get.offAllNamed('/login'); // Elimina todas las rutas y va a '/login'
4. Get.back() → Volver a la pantalla anterior (como pop)
Equivalente a: Navigator.pop()

Qué hace: Regresa a la pantalla anterior.

Ejemplo:

dart
Get.back(); // Vuelve atrás
5. Get.until() → Volver hasta una pantalla específica
Qué hace: Cierra pantallas hasta encontrar la ruta especificada.

Ejemplo:

dart
Get.until((route) => route.settings.name == '/home'); // Vuelve hasta '/home'
 */