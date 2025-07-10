
import 'package:get/get.dart';

import '../../infrastructure/shared/storage.dart';
import '../../screens/admin/dashboard_admin.dart';
import '../../screens/auth/login.dart';
import '../../screens/department/egreso/egreso.dart';
import '../../screens/department/planificacion/planificacion.dart';
import '../../vataciones/index.dart';
//import '../../screens/user/dashboard_user.dart';

//import '../presentation/home/home_screen.dart';
//import '../presentation/reports/reports_screen.dart';
import 'package:flutter/material.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final bool? status = LocalStorage.getStatus();
    if (status == null || status == false) {// sino esta logeado ve alo login
      return RouteSettings(name: '/login');
    }
  //  return RouteSettings(name: route);
    return null;
  }
}



class AppRoutes {
  static const String votacion='/votacion';
  static const String login = '/login';
  static const String dashboardSuperAdmin = '/superAdmin';
  //static const String dashboardAdmin = '/admin';
  //static const String dashboardUser = '/user';
  //static const String dashboardUser = '/user';

  // Rutas para departamentos
  static const String dashboardTecnologia = '/tecnologia';
  static const String dashboardAdministracion = '/administracion';
  static const String dashboardEgreso = '/egreso';
  static const String dashboardIngreso = '/ingreso';
  static const String dashboardCuentaUnica = '/cuentaunica';
  static const String dashboardPlanificacionAnalisisFinanciero = '/planificacionanalisisfinanciero';

  //static const String dashboardRecaudacionIngreso = '/recaudacioningreso';
  static const String dashboardRecursosHumanos = '/recursoshumanos';
  static const String dashboardInversionesValores = '/inversionesvalores';
  static const String dashboardConsultoriaJuridica = '/consultoriajuridica';


  // Lista de rutas para GetPages
  static final List<GetPage> routes = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: dashboardSuperAdmin, page: () => DashboardAdmin(),middlewares: [AuthMiddleware()]),
    GetPage(name: votacion, page: () => Index()),
    GetPage(name: dashboardPlanificacionAnalisisFinanciero, page: () => Planificacion(),middlewares: [AuthMiddleware()]),
    GetPage(name: dashboardEgreso, page: () => Egreso(),middlewares: [AuthMiddleware()]),


    //GetPage(name: dashboardAdmin, page: () => DashboardAdmin()),
    //GetPage(name: dashboardUser, page: () => DashboardUser()),

  // Dashboards por departamento
    /*GetPage(name: dashboardTecnologia, page: () => DashboardTecnologia()),
    GetPage(name: dashboardAdministracion, page: () => DashboardAdministracion()),

    GetPage(name: dashboardIngreso, page: () => DashboardIngreso()),
    GetPage(name: dashboardCuentaUnica, page: () => DashboardCuentaUnica()),

    //GetPage(name: dashboardRecaudacionIngreso, page: () => DashboardRecaudacionIngreso()),
    GetPage(name: dashboardRecursosHumanos, page: () => DashboardRecursosHumanos()),
    GetPage(name: dashboardInversionesValores, page: () => DashboardInversionesValores()),
    GetPage(name: dashboardConsultoriaJuridica, page: () => DashboardConsultoriaJuridica( // Dashboards por departamento

     */
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