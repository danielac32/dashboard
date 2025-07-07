import 'package:core_system/screens/auth/login.dart';
import 'package:core_system/screens/department/egreso/report_sigecof/shared/controller_shared.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/shared/controller_shared.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'core/app/routes.dart';
import 'core/config/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/utils/constants.dart';
import 'infrastructure/shared/storage.dart';


Future<void> main() async {
  await GetStorage.init();
  LocalStorage.saveStatus(false);
  WidgetsFlutterBinding.ensureInitialized();
  final config=await ConfigLoader.loadConfig();
  //print(config['api_url']);
  AppStrings.urlApi=config['api_url'];//carga la url de la api el backend de dart
  AppStrings.urlApiSigecof=config['api_sigecof'];// carga la url de la api de oracle en java

  /*
  ests controladores se usan para cada vista , para tener un titulo mientras el drawer al darle a cada opcion
  cambia el titulo
   */
  Get.put(SharedController());//planificacion
  Get.put(SharedEgresoController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Core',
      debugShowCheckedModeBanner: false,
      //theme: AppTheme(selectedColor: 0).theme(),
      //darkTheme: AppTheme(selectedColor: 4, isDarkMode: true).theme(),
      theme: ThemeData.dark(), // 👈 Aquí se activa el modo oscuro global
      darkTheme: ThemeData.dark(), // Opcional: define un darkTheme explícito
      themeMode: ThemeMode.dark,   //
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
      unknownRoute: GetPage(name: '/login', page: () => LoginScreen()),

    );
  }
}
