import 'package:core_system/vataciones/search/buscar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';

import 'controller/busqueda_controller.dart';
import 'graph/grafica.dart';
import 'interface/empleado.dart';



class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BusquedaController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Obx(() => _buildCircularStatCard(
                'Votaron',
                controller.votaronCount.value,
                Colors.green,Icons.how_to_vote,
              )),
              SizedBox( width: 40,),
              Obx(() => _buildCircularStatCard(
                'No votaron',
                controller.noVotaronCount.value,
                Colors.red,Icons.block,
              )),
              SizedBox( width: 40,),
              Obx(() => _buildCircularStatCard(
                'Total',
                controller.total.value,
                Colors.blue,Icons.group,
              )),
            ],
          ),
          backgroundColor: Color.fromARGB(200, 50, 50, 50), // Gris muy claro
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.search), text: "Buscar"),
              Tab(icon: Icon(Icons.bar_chart), text: "Gráfica"),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFFFAFAFA), // Fondo claro general
          child: TabBarView(
            children: [
              BuscarEmpleadoTab(),
              GraficaVotosTab(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildStatCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularStatCard(String title, int count, Color color,IconData ico) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono pequeño

          Icon(
            ico,//title == 'Votaron' ? Icons.how_to_vote : Icons.block,
            size: 16, // Tamaño reducido para que quepa bien
            color: color,
          ),

          const SizedBox(width: 4), // Espacio entre icono y número

          // Número pequeño
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}









// ================== TAB 2: GRÁFICA DE VOTOS POR DIRECCIÓN ==================
