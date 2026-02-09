
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/theme/app_theme.dart';
import '../../../infrastructure/entities/user_response.dart';
import '../../admin/widget/drawer_header.dart';
import '../../admin/widget/item_widget.dart';

import '../../auth/controller/login_controller.dart';
import 'controller.dart';
import './widget/item_user.dart';

class Ivss extends StatelessWidget {
  Ivss({super.key});
  final controllerIvss = Get.put(ControllerScreenIvss());

  @override
  Widget build(BuildContext context) {
    // 👇 Aquí forzamos el tema oscuro solo para esta pantalla
    return Theme(
      data: ThemeData.dark(), // Fuerza el tema oscuro
      child: Builder(
        builder: (context) {
          final colors = Theme.of(context).colorScheme;
          User user = Get.arguments['user'] as User;

          if (user == null) {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: const Center(child: Text("No se proporcionó un usuario.")),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: Obx(() => Text("${controllerIvss.Titulo} ${controllerIvss.addTitle.value}"),),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              backgroundColor: AppTheme.goldColor,//colors.primary,
              foregroundColor: Colors.black,//colors.onPrimary,
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerWidget(colors: colors, user: user),

                  Obx(() {
                    if (!controllerIvss.hasConnection.value) {
                      return ItemWidget(
                          icon: Icons.signal_wifi_statusbar_connected_no_internet_4,
                          colors: Colors.red,
                          text: 'Sin conexión',
                          tap: controllerIvss.connection//Get.back,
                      );
                    } else {
                      return SizedBox.shrink(); // No muestra nada
                    }
                  }),
                  // ItemWidget(icon: Icons.home, colors: AppTheme.goldColor/*colors.primary*/, text: 'Home', tap: Get.back),
                  ItemWidget(icon: Icons.account_circle, colors: AppTheme.goldColor, text: 'Perfil', tap: Get.back),
                  ItemsUser(),
                  Divider(),
                  ItemWidget(icon: Icons.logout, colors: Colors.red, text: 'Cerrar sesión', tap: () {
                    Get.back();
                    Get.find<LoginController>().logout();//controllerScreen.logout();
                  }),
                ],
              ),
            ),
            body: Obx(() => controllerIvss.currentView),
          );
        },
      ),
    );
  }
}