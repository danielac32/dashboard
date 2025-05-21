import 'package:flutter/material.dart';
import 'core/app/routes.dart';
import 'core/config/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/utils/constants.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config=await ConfigLoader.loadConfig();
  //print(config['api_url']);
  AppStrings.urlApi=config['api_url'];
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
      theme: AppTheme(selectedColor: 0).theme(),
      initialRoute: AppRoutes.votacion,//AppRoutes.login,
      getPages: AppRoutes.routes,
    );
  }
}
