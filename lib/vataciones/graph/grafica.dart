import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controller/grafica_controller.dart';
import '../interface/voto_direccion.dart';

class GraficaVotosTab extends StatelessWidget {
  final GraficaController controller = Get.put(GraficaController());

  GraficaVotosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Título
          const Text(
            'Estadísticas de Votación',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.black),
          ),
          const SizedBox(height: 10),

          // Botones de navegación entre gráficas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => ElevatedButton.icon(
                onPressed: () => controller.setGraficaIndex(0),
                icon: const Icon(Icons.pie_chart),
                label: const Text('Circular'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  controller.graficaIndex.value == 0 ? Colors.teal : Colors.grey.shade300,
                  foregroundColor:
                  controller.graficaIndex.value == 0 ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              )),
              const SizedBox(width: 10),
              Obx(() => ElevatedButton.icon(
                onPressed: () => controller.setGraficaIndex(1),
                icon: const Icon(Icons.bar_chart),
                label: const Text('Barras'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  controller.graficaIndex.value == 1 ? Colors.teal : Colors.grey.shade300,
                  foregroundColor:
                  controller.graficaIndex.value == 1 ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              )),
              const SizedBox(width: 10),
              Obx(() => ElevatedButton.icon(
                onPressed: () => controller.setGraficaIndex(2),
                icon: const Icon(Icons.show_chart),
                label: const Text('Línea'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  controller.graficaIndex.value == 2 ? Colors.teal : Colors.grey.shade300,
                  foregroundColor:
                  controller.graficaIndex.value == 2 ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              )),
            ],
          ),

          const SizedBox(height: 20),

          // Contenedor dinámico para las gráficas
          Expanded(
            child: Obx(() {
              if (controller.votosData.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return IndexedStack(
                index: controller.graficaIndex.value,
                children: [
                  // 1. Gráfica Circular
                  SfCircularChart(
                    //title: ChartTitle(text: 'Distribución de Votos por Dirección',textStyle: TextStyle(color: Colors.black)),
                    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap,textStyle: TextStyle(
                      color: Colors.black, // Cambia este color según necesites
                      //fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),),
                    series: <CircularSeries>[
                      PieSeries<VotoDireccion, String>(
                        dataSource: controller.votosData,
                        xValueMapper: (VotoDireccion data, _) => data.nombre,
                        yValueMapper: (VotoDireccion data, _) => data.votos,
                        dataLabelSettings: const DataLabelSettings(isVisible: true,textStyle: TextStyle(color: Colors.black,fontSize: 14)),
                        enableTooltip: true,
                      )
                    ],
                  ),

                  // 2. Gráfica de Barras
                  SfCartesianChart(
                   // title: ChartTitle(text: 'Votos por Dirección General'),


                    primaryXAxis: CategoryAxis(
                      axisLine: AxisLine(color: Colors.black), // Color del eje X
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black), // Color de las etiquetas del eje X
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 60,
                      interval: 10,
                      axisLine: AxisLine(color: Colors.black), // Color del eje Y
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black), // Color de las etiquetas del eje Y
                    ),
                    legend: Legend(
                      isVisible: true,
                      textStyle: TextStyle(
                        color: Colors.black, // Color del texto de la leyenda
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <BarSeries<VotoDireccion, String>>[
                      BarSeries<VotoDireccion, String>(
                        //name: 'Votos',
                        dataSource: controller.votosData,
                        xValueMapper: (VotoDireccion data, _) => data.nombre,
                        yValueMapper: (VotoDireccion data, _) => data.votos,
                        dataLabelSettings: const DataLabelSettings(isVisible: true,textStyle: TextStyle(color: Colors.black,fontSize: 14)),
                      ),
                    ],
                  ),

                  // 3. Gráfica de Líneas
                  SfCartesianChart(
                    //title: ChartTitle(text: 'Evolución de Votos por Dirección'),
                    primaryXAxis: CategoryAxis(
                      axisLine: AxisLine(color: Colors.black), // Color del eje X
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black), // Color de las etiquetas del eje X
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 60,
                      interval: 10,
                      axisLine: AxisLine(color: Colors.black), // Color del eje Y
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black), // Color de las etiquetas del eje Y
                    ),
                    legend: Legend(
                      isVisible: true,
                      textStyle: TextStyle(
                        color: Colors.black, // Color del texto de la leyenda
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <LineSeries<VotoDireccion, String>>[
                      LineSeries<VotoDireccion, String>(
                        //name: 'Votos',
                        dataSource: controller.votosData,
                        xValueMapper: (VotoDireccion data, _) => data.nombre,
                        yValueMapper: (VotoDireccion data, _) => data.votos,
                        markerSettings: const MarkerSettings(isVisible: true),
                        enableTooltip: true,
                        dataLabelSettings: const DataLabelSettings(isVisible: true,textStyle: TextStyle(color: Colors.black,fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}