
import 'package:core_system/screens/department/egreso/report_sigecof/controller/controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../infrastructure/entities/user_response.dart';
import '../../admin/controller/dashboard_menu.dart';
import '../../admin/widget/drawer_header.dart';
import '../../admin/widget/item_widget.dart';
import './report_sigecof/shared/controller_shared.dart';
import './report_sigecof/widget/item_user.dart';

class Egreso extends StatelessWidget {
  final  controllerScreen = Get.put(MenuControllerScreen());
  final  controllerEgreso = Get.put(ControllerScreenEgreso());
  final  controllerShared = Get.find<SharedEgresoController>();
   Egreso({super.key});

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
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        actions: <Widget>[


        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerWidget(colors: colors, user: user,),
            ItemWidget(icon:Icons.home,colors:colors.primary,text: 'Home',tap: (){
              Get.back();
            }),
            ItemWidget(icon:Icons.account_circle,colors:colors.primary,text: 'Perfil',tap: (){
              Get.back();
            }),
            ItemsUser(),
            Divider(),
            ItemWidget(icon:Icons.logout,colors:colors.error,text: 'Cerrar sesión',tap:(){
              Get.back();
              controllerScreen.logout();
            }),
          ],
        ),
      ),
      body: Obx((){
        // return menuControllerScreen.screens[menuControllerScreen.currentIndex.value];
        return controllerEgreso.currentView;
      }),
    );
  }
}
