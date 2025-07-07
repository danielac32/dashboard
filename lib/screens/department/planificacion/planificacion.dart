

import 'package:core_system/screens/department/planificacion/report_sigecof/controller/controller_screen.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/shared/controller_shared.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/widget/item_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/theme/app_theme.dart';
import '../../../infrastructure/entities/user_response.dart';


import '../../admin/controller/dashboard_menu.dart';
import '../../admin/widget/drawer_header.dart';
import '../../admin/widget/item_widget.dart';

class Planificacion extends StatelessWidget {
  final  controllerScreen = Get.put(MenuControllerScreen());
  final  controllerPlanificacion = Get.put(ControllerScreenPlanificacion());
  final  controllerShared = Get.find<SharedController>();

  Planificacion({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    User user = Get.arguments['user'] as User;
    //print(user.position);
    print(user.toString());
    // Verificar si el argumento es nulo
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("No se proporcionó un usuario."),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Obx(() => Text("${controllerShared.Titulo} ${controllerShared.addTitle.value}"),),
        ),

        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Abre el Drawer
            },
          ),
        ),
        backgroundColor: AppTheme.goldColor,//colors.primary,
        foregroundColor: Colors.black,//colors.onPrimary,
        actions: <Widget>[


        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerWidget(colors: colors, user: user,),
            Obx(() {
              if (!controllerPlanificacion.hasConnection.value) {
                return ItemWidget(
                  icon: Icons.signal_wifi_statusbar_connected_no_internet_4,
                  colors: Colors.red,
                  text: 'Sin conexión',
                  tap: Get.back,
                );
              } else {
                return SizedBox.shrink(); // No muestra nada
              }
            }),
            //ItemWidget(icon: Icons.home, colors: AppTheme.goldColor/*colors.primary*/, text: 'Home', tap: Get.back),
            ItemWidget(icon:Icons.account_circle,colors:AppTheme.goldColor,text: 'Perfil',tap: (){
              Get.back();
            }),
            ItemsUser(),
            Divider(),
            ItemWidget(icon:Icons.logout,colors:Colors.red,text: 'Cerrar sesión',tap:(){
              Get.back();
              controllerScreen.logout();
            }),
          ],
        ),
      ),
      body: Obx((){
        // return menuControllerScreen.screens[menuControllerScreen.currentIndex.value];
        return controllerPlanificacion.currentView;
      }),
    );
  }
}
