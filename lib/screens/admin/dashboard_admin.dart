
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widget/drawer_header.dart';
import '../../infrastructure/entities/user.dart';
import 'widget/item_widget.dart';
import 'widget/items_config/items_config.dart';
import 'widget/items_content/items_content.dart';
import 'widget/items_user/items_user.dart';




class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final UserEntity? user = Get.arguments as UserEntity?;
    user.toString();
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
        title: Text('Dashboard'),
        centerTitle: true,
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerWidget(colors: colors, user: user,),
            ItemWidget(icon:Icons.home,colors:colors.primary,text: 'Inicio'),
            ItemsUser(),
            ItemsContent(),
            ItemsConfig(),
            Divider(),
            ItemWidget(icon:Icons.logout,colors:colors.error,text: 'Cerrar sesión'),

          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    50,
                        (index) => ListTile(
                      title: Text('Item ${index + 1}'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Footer
          Container(
            height: 60,
            color: colors.secondaryContainer,
            child: Center(
              child: Text(
                'Footer',
                style: TextStyle(
                  color: colors.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}