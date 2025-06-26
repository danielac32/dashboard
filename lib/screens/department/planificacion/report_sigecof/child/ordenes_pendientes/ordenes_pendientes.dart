import 'package:core_system/screens/department/planificacion/report_sigecof/child/ordenes_pendientes/controller/controller.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/child/ordenes_pendientes/widget/consultar.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/child/ordenes_pendientes/widget/descargar.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/child/ordenes_pendientes/widget/desde.dart';
import 'package:core_system/screens/department/planificacion/report_sigecof/child/ordenes_pendientes/widget/hasta.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class OrdenesPendientes extends StatelessWidget {
   OrdenesPendientes({super.key});
  final controller = Get.put(PendienteController());

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
                                rows: controller.paginatedResults.map((pendiente) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(controller.formatDate(pendiente.fechaModificacion?? ""))),
                                      DataCell(Text(pendiente.estado.toString())),
                                      DataCell(Text(pendiente.orden.toString())),
                                      DataCell(Text('\$${pendiente.monto.toStringAsFixed(2) ?? '0.00'}')),
                                      DataCell(Text(pendiente.fuente)),
                                      DataCell(Text(pendiente.anho.toString())),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                                          child: Tooltip(
                                            message: pendiente.partida,
                                            child: Text(
                                              pendiente.partida.length > 30
                                                  ? '${pendiente.partida!.substring(0, 30)}...'
                                                  : pendiente.partida ?? '',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(pendiente.cuenta ?? '')),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                                          child: Tooltip(
                                            message: pendiente.observacion,
                                            child: Text(
                                              pendiente.observacion.length > 30
                                                  ? '${pendiente.observacion.substring(0, 30)}...'
                                                  : pendiente.observacion ?? '',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                                          child: Tooltip(
                                            message: pendiente.organismo,
                                            child: Text(
                                              pendiente.organismo.length > 30
                                                  ? '${pendiente.organismo.substring(0, 30)}...'
                                                  : pendiente.organismo ?? '',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.2),
                                          child: Tooltip(
                                            message: pendiente.beneficiario,
                                            child: Text(
                                              pendiente.beneficiario.length > 30
                                                  ? '${pendiente.beneficiario.substring(0, 30)}...'
                                                  : pendiente.beneficiario ?? '',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(pendiente.fondo ?? '-')),
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

