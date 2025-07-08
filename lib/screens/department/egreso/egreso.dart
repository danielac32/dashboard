import 'package:core_system/screens/department/egreso/report_sigecof/controller/controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/config/theme/app_theme.dart';
import '../../../infrastructure/entities/user_response.dart';
import '../../admin/controller/dashboard_menu.dart';
import '../../admin/widget/drawer_header.dart';
import '../../admin/widget/item_widget.dart';
import '../../auth/controller/login_controller.dart';
import './report_sigecof/shared/controller_shared.dart';
import './report_sigecof/widget/item_user.dart';

class Egreso extends StatelessWidget {
  //final controllerScreen = Get.put(MenuControllerScreen());
  final controllerEgreso = Get.put(ControllerScreenEgreso());
  final controllerShared = Get.find<SharedEgresoController>();

  Egreso({super.key});

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
              //title: Obx(() => Text("${controllerShared.Titulo} ${controllerShared.addTitle.value}")),
              title: Center(
                child: Obx(() => Text("${controllerShared.Titulo} ${controllerShared.addTitle.value}"),),
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
                    if (!controllerEgreso.hasConnection.value) {
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
            body: Obx(() => controllerEgreso.currentView),
          );
        },
      ),
    );
  }
}