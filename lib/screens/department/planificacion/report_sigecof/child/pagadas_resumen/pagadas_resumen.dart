
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../../../core/config/theme/app_theme.dart';
import '../../../../shared_widget/date.dart';
import '../../../../shared_widget/generic_consult.dart';
import '../../../../shared_widget/generic_download.dart';
import 'controller/resumen_controller.dart';


class ResumenPagadas extends StatelessWidget {
  ResumenPagadas({super.key});
  final controller = Get.put(PagadasResumenController());


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
                        await controller.cargarPagadasResumen(
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
                                  DataColumn(label: Text("Partidas", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("Año Anterior", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("Año Actual", style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text("Monto Total", style: TextStyle(color: Colors.black))),
                                ],
                                rows: [
                                  // Filas de datos (cada organismo)
                                  ...controller.res.map((resumen) {
                                    return DataRow(
                                      cells: [
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
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(resumen?.partidas?.toString() ?? "-", style: TextStyle(color: Colors.black))),
                                        DataCell(Text(resumen?.anhoAnterior?.toString() ?? "-", style: TextStyle(color: Colors.black))),
                                        DataCell(Text(resumen?.anhoActual?.toString() ?? "-", style: TextStyle(color: Colors.black))),
                                        DataCell(Text(resumen?.montoTotal?.toString() ?? "-", style: TextStyle(color: Colors.black))),
                                      ],
                                    );
                                  }).toList(),

                                  // 2. Fila de total general (solo si hay datos)
                                ],
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









