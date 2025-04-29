

import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
/*import 'dart:io'; // Para trabajar con File
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:cross_file/cross_file.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert'; // Para codificar/decodificar JSON*/


class CarouselController extends GetxController {
  // Índice actual del carrusel
  var currentIndex = 0.obs;
  var cover = true.obs;

  // Lista de imágenes locales
  final List<String> items = [
    "assets/1.jpeg",
    "assets/2.jpeg",
    "assets/3.jpeg",
    "assets/4.jpeg",
    "assets/5.jpeg",
  ];



  // Método para cambiar el índice actual
  void changeIndex(int index) {
    currentIndex.value = index;
  }
  void transform(){
    cover.value ^=true ;
  }

}


class CarouselView extends StatelessWidget {
  final CarouselController controller = Get.put(CarouselController());

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor:colors.onSecondary,
      body: Column(
        children: [
          /*Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: ()  {
                // Usa FilePicker para seleccionar una imagen

              },
              child: Text('Subir nuevas imágenes'),
            ),
          ),*/

          // Espaciador para separar el carrusel de la parte superior
          SizedBox(height: 5),
          // Carrusel (limitado al 80% del ancho de la pantalla)
          Center(
            child: Container(
              width: screenWidth * 0.7, // 80% del ancho de la pantalla
              height: screenHeight * 0.3, // 30% del alto de la pantalla
              child: Obx(() {
                return CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    initialPage: 2,
                    autoPlay: true,
                  ),
                  items: controller.items.map((item) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Stack(
                          children: <Widget>[
                            // Imagen local con ajuste dinámico
                            Image.asset(
                              item,
                              fit: controller.cover.value ? BoxFit.cover : BoxFit.contain, // Alternar entre cover y contain
                              width: double.infinity,
                            ),
                            // Capa con degradado y botón
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(100, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Botón con ícono en la esquina inferior izquierda
                                    IconButton(
                                      icon: Icon(Icons.transform, color: Colors.white, size: 24),
                                      onPressed: () {
                                        // Alternar el estado de cover
                                        print(controller.cover.value);
                                        controller.transform();
                                      },
                                    ),
                                    // Espacio vacío para centrar el botón a la izquierda
                                    SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ),

          // Cuadro inferior (70% del alto de la pantalla)
          //Content(screenWidth: screenWidth),
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        width: screenWidth * 0.9, // 90% del ancho de la pantalla
        margin: EdgeInsets.all(20.0),
        foregroundDecoration: BoxDecoration(
            color: colors.secondary,
          borderRadius: BorderRadius.circular(15.0),
        ), // Margen reducido
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // Color del cuadro basado en el tema
          borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Sombra ligera
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Contenido aquí',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              //color: Theme.of(context).textTheme.bodyText1!.color, // Color de texto basado en el tema
            ),
          ),
        ),
      ),
    );
  }
}




class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            // Sección del Carrusel
            _buildCarouselSection(),

            // Contenido principal y aside
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    // Vista de escritorio
                    return _buildDesktopLayout();
                  } else {
                    // Vista móvil
                    return _buildMobileLayout();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contenido principal (artículos)
        Expanded(
          flex: 3,
          child: _buildArticlesSection(),
        ),

        const SizedBox(width: 20),

        // Aside (destacados)
        Expanded(
          flex: 1,
          child: _buildAsideSection(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Contenido principal (artículos)
        _buildArticlesSection(),

        const SizedBox(height: 20),

        // Aside (destacados)
        _buildAsideSection(),
      ],
    );
  }

  // Carrusel modificado para usar GetX e imágenes locales
  Widget _buildCarouselSection() {

    final CarouselController controller = Get.put(CarouselController());
    return Column(
      children: [
        CarouselSlider.builder(
          //carouselController: controller,
          itemCount: controller.items.length,
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            aspectRatio: 16/9,
            viewportFraction: 1.0,
            autoPlayInterval: const Duration(seconds: 2),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              controller.changeIndex(index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return Obx(() => GestureDetector(
              onTap: () => controller.transform(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: controller.cover.value
                      ? Image.asset(
                    controller.items[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                      : Transform(
                    transform: Matrix4.identity()
                      ..rotateY(pi)
                      ..rotateZ(0.1),
                    alignment: Alignment.center,
                    child: Image.asset(
                      controller.items[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ));
          },
        ),
        const SizedBox(height: 12),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            controller.items.length,
                (index) => Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.currentIndex.value == index
                    ? Colors.blue
                    : Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
        )),
      ],
    );
  }





  Widget _buildGallerySection(){
       return Container(
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(12),
           color: Colors.white,
           boxShadow: [
             BoxShadow(
               color: Colors.grey.withOpacity(0.2),
               spreadRadius: 2,
               blurRadius: 5,
               offset: const Offset(0, 3),
             ),
           ],
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             const Text(
               'Galería de Imágenes',
               style: TextStyle(
                 fontSize: 18,
                 fontWeight: FontWeight.bold,
               ),
             ),
             const SizedBox(height: 12),
             SizedBox(
               height: 150,
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount: 5,
                 itemBuilder: (context, index) {
                   return Container(
                     width: 200,
                     margin: const EdgeInsets.only(right: 10),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(8),
                       image: DecorationImage(
                         image: AssetImage('assets/${index + 1}.jpeg'),
                         fit: BoxFit.cover,
                       ),
                     ),
                   );
                 },
               ),
             ),
             const SizedBox(height: 16),
             const Text(
               'Contenido adicional puede ir aquí...',
               style: TextStyle(fontSize: 14),
             ),
           ],
         ),
       );
  }


  Widget _buildArticlesSection() {
    return Column(
      children: [
        // Contenedor con scroll para los artículos
        Container(
          height: 400, // Altura fija para el área de scroll
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 15,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Título del artículo ${index + 1}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Publicado el 15 de junio, 2023',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Nullam in dui mauris. Vivamus hendrerit arcu sed erat '
                            'molestie vehicula. Sed auctor neque eu tellus rhoncus '
                            'ut eleifend nibh porttitor...',
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Leer más'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),
        // Sección adicional para imágenes o más contenido
        _buildGallerySection(),
        const SizedBox(height: 20),
        // Sección de estadísticas
        _buildStatisticsSection(),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Container(

      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estadísticas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                        return Text(days[value.toInt()]);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (index + 1) * 10.0 + 20,
                        color: Colors.blue,
                        width: 16,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate(int index) {
    final date = DateTime.now().subtract(Duration(days: index * 2));
    return '${date.day}/${date.month}/${date.year}';
  }


  // Sección aside (destacados)
  Widget _buildAsideSection() {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Artículos destacados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(10, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        'Artículo destacado ${index + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 400, // Altura fija
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.builder( // Directamente ListView sin Column
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) => ListTile(
              title: Text('Item $index'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16), // Añadir padding
            ),
          ),
        )
      ],
    );
  }
}