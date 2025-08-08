
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../../../core/config/theme/app_theme.dart';
import '../../../../shared_widget/date.dart';
import '../../../../shared_widget/generic_consult.dart';
import '../../../../shared_widget/generic_download.dart';
import 'controller/controller.dart';

class OrdenesPagadasPartidas extends StatelessWidget {
  OrdenesPagadasPartidas({super.key});
  final controller = Get.put(PagadasPartidasController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fila de filtros compacta
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color:  AppTheme.goldColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Obx(() =>GenericDatePickerField(
                          primaryColor: AppTheme.goldColor,
                          initialDate: controller.fechaDesde.value,
                          onDateSelected: (date) {
                            controller.fechaDesde.value = date;
                            // Puedes llamar a cualquier función adicional aquí
                          },
                          isLoading: controller.cargando.value,
                          label: 'Desde',
                        )),
                        const SizedBox(width: 8),
                      Obx(() =>GenericDatePickerField(
                          initialDate: controller.fechaHasta.value,
                          onDateSelected: (date) {
                            controller.fechaHasta.value = date;
                          },
                          isLoading: controller.cargando.value,
                          label: 'Hasta',
                          primaryColor: AppTheme.goldColor,
                        )),
                        const SizedBox(width: 12),
                        Obx(() =>GenericConsultButton(
                          isLoading: controller.cargando.value,
                          onConsult: () async {
                            await controller.cargarPagadasPartidas(
                              controller.fechaDesde.value,
                              controller.fechaHasta.value,
                            );
                          },
                        )),
                        const SizedBox(width: 12),
                          Obx(() =>GenericDownloadButton(
                          isLoading: controller.cargando.value,
                          onDownload: () async {
                            await controller.descargarReporte();
                          },
                        ))
                      ],
                  ),
              ),
              const SizedBox(height: 16),

              // Tabla con scroll horizontal y vertical
              Expanded(

                child: Obx(() {

                  if (controller.cargando.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.res.isEmpty) {
                    return Center(
                      child: Text( "No hay registros para mostrar",
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [

                        SizedBox(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(
                                  color: Colors.grey, // Color del borde
                                  width: 1.0,         // Grosor del borde
                                  style: BorderStyle.solid, // Estilo sólido como Excel
                                ),
                                columnSpacing: 10,
                                horizontalMargin: 10,
                                showCheckboxColumn: false,
                                dataRowColor: WidgetStateProperty.all(Colors.white),
                                headingRowColor: WidgetStateProperty.all(AppTheme.goldColor),
                                columns: const [
                                  DataColumn(label: Text("Organismo", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("401", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("402", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("403", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("404", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("405", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("406", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("407", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("408", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("409", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("410", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("411", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("total", style: TextStyle(color: Colors.black))),
                                ],
                                rows: (controller.res ?? []).map((resumen) {
                                  // Manejo seguro de propiedades null
                                  return DataRow(
                                    cells: [
                                      //DataCell(Text(resumen.organismo, style: TextStyle(color: Colors.black))),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.3,
                                          ),
                                          child: Tooltip(
                                            message: resumen.organismo,
                                            child: Text(
                                              resumen.organismo.length > 20
                                                  ? '${resumen.organismo.substring(0, 20)}...'
                                                  : resumen.organismo,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(resumen.partida401.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.partida402.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.partida403.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.partida404.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.partida405.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.partida406.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.partida407.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.partida408.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.partida409.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.partida410.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.partida411.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                      DataCell(Text(resumen.total.toStringAsFixed(2), style: TextStyle(color: Colors.black))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}









