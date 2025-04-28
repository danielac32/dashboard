
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/dashboard_menu.dart';
import 'widget/drawer_header.dart';
import '../../infrastructure/entities/user.dart';
import 'widget/item_widget.dart';
import 'widget/items_config/items_config.dart';
import 'widget/items_content/items_content.dart';
import 'widget/items_user/items_user.dart';




class DashboardAdmin extends StatelessWidget {
   DashboardAdmin({super.key});
  final  menuControllerScreen = Get.put(MenuControllerScreen());


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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Inicio',
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('This is a snackbar')));
              },
            ),
            // Para Quiénes Somos
            IconButton(
              icon: const Icon(Icons.people),
              tooltip: 'Quiénes Somos',
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('This is a snackbar')));
              },
            ),

            // Para Contáctanos
            IconButton(
              icon: const Icon(Icons.contact_mail),
              tooltip: 'Contáctanos',
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('This is a snackbar')));
              },
            ),

            // Para Multimedia
            IconButton(
              icon: const Icon(Icons.collections),
              tooltip: 'Multimedia',
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('This is a snackbar')));
              },
            ),

            // Para Publicaciones
            IconButton(
              icon: const Icon(Icons.article),
              tooltip: 'Publicaciones',
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('This is a snackbar')));
              },
            ),
            IconButton(
              icon: const Icon(Icons.newspaper),
              tooltip: 'Noticias',
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('This is a snackbar')));
              },
            )
          ],
        ),
        //centerTitle: true,
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
            ItemWidget(icon:Icons.home,colors:colors.primary,text: 'Inicio'),
            ItemsUser(),
            ItemsContent(),
            ItemsConfig(),
            Divider(),
            ItemWidget(icon:Icons.logout,colors:colors.error,text: 'Cerrar sesión'),

          ],
        ),
      ),
      body: Obx((){
        return menuControllerScreen.screens[menuControllerScreen.currentIndex.value];
      }),
      //  body: Home()
      /*Column(
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
      ),*/

    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colors.shadow,
            ),

            child: SizedBox(
              height: 100,
              width: 100,
              child: Center(child: Text("cuadro 1"),),
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colors.onSecondaryContainer,

            ),
            child: SizedBox(
              height: 100,
              width: 100,
              child: Center(child: Text("cuadro 2"),),
            ),
          ),
        ],
      ),
    );
  }
}
