
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../../../core/config/theme/app_theme.dart';
import '../../../../shared_widget/date.dart';
import '../../../../shared_widget/generic_consult.dart';
import '../../../../shared_widget/generic_download.dart';
import 'controller/controller.dart';
class OrdenesPagadas extends StatelessWidget {
   OrdenesPagadas({super.key});
  final controller = Get.put(PagadasController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                          await controller.cargarPagadas(
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

                if (controller.resultados.isEmpty) {
                  return Center(
                    child: Text( "No hay registros para mostrar",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Registros: ${controller.resultados?.length ?? 0} en páginas de ${controller.itemsPerPage}",
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: DataTable(
                              columnSpacing: 10,
                              horizontalMargin: 10,
                              showCheckboxColumn: false,
                              dataRowColor: WidgetStateProperty.all(Colors.white),
                              headingRowColor: WidgetStateProperty.all(AppTheme.goldColor),
                              columns: const [
                                DataColumn(label: Text("Monto", style: TextStyle(color: Colors.black))),
                                DataColumn(label: Text("Estado", style: TextStyle(color: Colors.black))),
                                DataColumn(label: Text("Moneda", style: TextStyle(color: Colors.black))),
                                DataColumn(label: Text("Orden", style: TextStyle(color: Colors.black))),
                                DataColumn(label: Text("Presupuesto", style: TextStyle(color: Colors.black))),
                                DataColumn(label: Text("Lugar", style: TextStyle(color: Colors.black))),
                                DataColumn(label: Text("Fecha", style: TextStyle(color: Colors.black))),
                                DataColumn(label: Text("Partida", style: TextStyle(color: Colors.black))),
                                DataColumn(label: Text("Observación", style: TextStyle(color: Colors.black))),
                                DataColumn(label: Text("Organismo", style: TextStyle(color: Colors.black))),
                                DataColumn(label: Text("Beneficiario", style: TextStyle(color: Colors.black))),
                              ],
                              rows: (controller.paginatedResults ?? []).map((pagadas) {
                                // Manejo seguro de propiedades null
                                final montoNeto = pagadas?.montoNeto?.toString() ?? "-";
                                final estado = pagadas?.estado?.toString() ?? "-";
                                final moneda = pagadas?.moneda ?? "-";
                                final orden = pagadas?.orden?.toString() ?? "-";
                                final presupuesto = pagadas?.presupuesto?.toString() ?? "-";
                                final lugar = pagadas?.lugar ?? "-";
                                final fecha = controller.formatDate(pagadas?.fechaPago) ?? "-";
                                final partida = pagadas?.partida ?? "-";
                                final observacion = pagadas?.observacion ?? "-";
                                final organismo = pagadas?.organismo ?? "-";
                                final beneficiario = pagadas?.beneficiario ?? "-";

                                return DataRow(
                                  cells: [
                                    DataCell(Text(montoNeto, style: TextStyle(color: Colors.black))),
                                    DataCell(Text(estado, style: TextStyle(color: Colors.black))),
                                    DataCell(Text(moneda, style: TextStyle(color: Colors.black))),
                                    DataCell(Text(orden, style: TextStyle(color: Colors.black))),
                                    DataCell(Text(presupuesto, style: TextStyle(color: Colors.black))),
                                    DataCell(Text(lugar, style: TextStyle(color: Colors.black))),
                                    DataCell(Text(fecha, style: TextStyle(color: Colors.black))),
                                    DataCell(Text(partida, style: TextStyle(color: Colors.black))),
                                    DataCell(
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.3,
                                        ),
                                        child: Tooltip(
                                          message: observacion,
                                          child: Text(
                                            observacion.length > 30
                                                ? '${observacion.substring(0, 30)}...'
                                                : observacion,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.3,
                                        ),
                                        child: Tooltip(
                                          message: organismo,
                                          child: Text(
                                            organismo.length > 30
                                                ? '${organismo.substring(0, 30)}...'
                                                : organismo,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(beneficiario, style: TextStyle(color: Colors.black))),
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

            // Paginación
            Obx(() => controller.resultados.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: controller.currentPage.value > 0
                        ? () => controller.previousPage()
                        : null,
                  ),
                  Text(
                    'Página ${controller.currentPage.value + 1} de ${controller.totalPages}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: (controller.currentPage.value + 1) < controller.totalPages
                        ? () => controller.nextPage()
                        : null,
                  ),
                ],
              ),
            )
                : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}









