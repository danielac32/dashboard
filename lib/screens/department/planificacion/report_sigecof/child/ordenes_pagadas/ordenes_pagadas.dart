import 'package:core_system/screens/department/planificacion/report_sigecof/child/ordenes_pagadas/widget/consultar.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/child/ordenes_pagadas/widget/descargar.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/child/ordenes_pagadas/widget/desde.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/child/ordenes_pagadas/widget/dropdown.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/child/ordenes_pagadas/widget/hasta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'controller/controller.dart';
class OrdenesPagadas extends StatelessWidget {
   OrdenesPagadas({super.key});
  final controller = Get.put(PagoController());
  final report = Get.put(ReportsController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xfff4f6f9),
      /*appBar: AppBar(
        backgroundColor: const Color(0xFF1e3d7a),
        title: const Text("Sistema de Consulta SIGECOF"),
        centerTitle: true,
      ),*/
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DesdeWidget(controller: controller),
                      const SizedBox(width: 8),
                      HastaWidget(controller: controller),
                      const SizedBox(width: 12),
                      ConsultarWidget(controller: controller),
                      const SizedBox(width: 12),
                      DescargarWidget(controller: controller),
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
                    child: Text(
                      controller.filtro.value.isEmpty
                          ? "Seleccione una opción"
                          : "No hay registros para mostrar",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    //controller: controller.horizontalScrollController,
                    // scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Center(
                            child: Text("Registros: ${controller.resultados.length} en paginas de ${controller.itemsPerPage}",
                                style: const TextStyle(color: Colors.grey, fontSize: 16))
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: SingleChildScrollView(
                            //scrollDirection: Axis.vertical,
                            //controller: controller.verticalScrollController,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: DataTable(
                                columnSpacing: 20,
                                horizontalMargin: 12,
                                showCheckboxColumn: false,
                                dataRowColor: MaterialStateProperty.all(Colors.white),
                                headingRowColor: MaterialStateProperty.all(const Color(0xFF1e3d7a)),
                                columns: const [
                                  DataColumn(label: Text("Fecha", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Estado", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Orden", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Monto", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Fuente", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Año", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Partida", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Cuenta", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Observación", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Organismo", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Beneficiario", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Fondo", style: TextStyle(color: Colors.white))),
                                ],
                                rows: controller.paginatedResults.map((pago) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        /*SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.1,
                                            child: Text(pago.pagada),
                                          )*/
                                        /*ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                                            child: Text(pago.pagada)
                                          )*/
                                          Text(controller.formatDate(pago.pagada))
                                      ),
                                      DataCell(
                                        /*SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.02,
                                            child: Text(pago.estado.toString()),
                                          )*/
                                          Text(pago.estado.toString())
                                      ),
                                      DataCell(
                                        /* SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.02,
                                            child: Text(pago.orden.toString()),
                                          )*/
                                          Text(pago.orden.toString())
                                      ),
                                      DataCell(
                                        /*SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.05,
                                            child: Text('\$${pago.monto.toStringAsFixed(2)}'),
                                          )*/
                                          Text('\$${pago.monto.toStringAsFixed(2)}')
                                      ),
                                      DataCell(
                                        /*SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.1,
                                            child: Text(pago.fuente),
                                          )*/
                                          Text(pago.fuente)
                                      ),
                                      DataCell(Text(pago.anho.toString())),
                                      DataCell(
                                        /*ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.2),
                                            child: Text(pago.partida)
                                          )*/
                                        /*SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            child: Text(pago.partida),
                                          )*/
                                        //Text(pago.partida)
                                        ConstrainedBox(
                                          constraints:  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                                          child: Tooltip(
                                            message: pago.partida,
                                            child: Text(
                                              pago.partida.length > 30
                                                  ? '${pago.partida.substring(0, 30)}...'
                                                  : pago.partida,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        /* SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.1,
                                            child: Text(pago.cuenta),
                                          )*/
                                          Text(pago.cuenta)
                                      ),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints:  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                                          child: Tooltip(
                                            message: pago.observacion,
                                            child: Text(
                                              pago.observacion.length > 30
                                                  ? '${pago.observacion.substring(0, 30)}...'
                                                  : pago.observacion,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        /* SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.1,
                                            child: Text(pago.organismo),
                                          )*/
                                        //Text(pago.organismo)
                                        ConstrainedBox(
                                          constraints:  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                                          child: Tooltip(
                                            message: pago.organismo,
                                            child: Text(
                                              pago.organismo.length > 30
                                                  ? '${pago.organismo.substring(0, 30)}...'
                                                  : pago.organismo,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        /*SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.1,
                                            child: Text(pago.beneficiario),
                                          )*/
                                          Text(pago.beneficiario)
                                      ),
                                      DataCell(Text(pago.fondo ?? "-")),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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









