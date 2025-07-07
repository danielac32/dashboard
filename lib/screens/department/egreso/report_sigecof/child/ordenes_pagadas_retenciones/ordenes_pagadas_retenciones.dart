
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../../../core/config/theme/app_theme.dart';
import '../../../../shared_widget/date.dart';
import '../../../../shared_widget/generic_consult.dart';
import '../../../../shared_widget/generic_download.dart';
import 'controller/ordenes_pagadas_retenciones_controller.dart';



class OrdenesPagadasRetenciones extends StatelessWidget {
   OrdenesPagadasRetenciones({super.key});
  final controller = Get.put(EgresoOrdenesPagadasRetencionesController());
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
                     color: AppTheme.goldColor.withOpacity(0.1),
                     spreadRadius: 1,
                     blurRadius: 3,
                   ),
                 ],
               ),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Obx(() => GenericDatePickerField(
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
                         color: AppTheme.goldColor.withOpacity(0.1),
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
                           //width: MediaQuery.of(context).size.width,
                           child: SingleChildScrollView(
                             //scrollDirection: Axis.vertical,
                             //controller: controller.verticalScrollController,
                             scrollDirection: Axis.horizontal,
                             child: Padding(
                               padding: const EdgeInsets.all(5),
                               child: DataTable(
                                 /*columnSpacing: 20,
                                horizontalMargin: 12,*/
                                 columnSpacing: 4, // Reducir este valor
                                 horizontalMargin: 4, // Reducir este valor
                                 showCheckboxColumn: false,
                                 dataRowColor: WidgetStateProperty.all(Colors.white),
                                 headingRowColor: WidgetStateProperty.all(AppTheme.goldColor),
                                 columns: const [
                                   DataColumn(label: Text("Presupuesto", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Monto 1x500 ant", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("monto orden", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Monto 1x500", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Organismo", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Monto orden ant", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Beneficiario", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Rif", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Desc. Unidad Admin", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Orden", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Denominacion", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Cod. Unidad Admin", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Fecha", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Observacion", style: TextStyle(color: Colors.black))),
                                 ],
                                 rows: controller.paginatedResults.map((pago) {
                                   return DataRow(
                                     cells: [
                                       DataCell(Text(pago.presupuesto?.toString() ?? "-", style: TextStyle(color: Colors.black))),

                                       // Monto 1x500 ant (formato monetario)
                                       DataCell(Text(pago.monto1x500Ant != null
                                           ? '\$${pago.monto1x500Ant!.toStringAsFixed(2)}'
                                           : "-", style: TextStyle(color: Colors.black))),

                                       // Monto orden (formato numérico grande)
                                       DataCell(Text(pago.montoOrden?.toString() ?? "-", style: TextStyle(color: Colors.black))),

                                       DataCell(Text(pago.monto1x500?.toString() ?? "-", style: TextStyle(color: Colors.black))),
                                       // Organismo (con tooltip para texto largo)
                                       DataCell(
                                         ConstrainedBox(
                                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.2),
                                           child: Tooltip(
                                             message: pago.organismo ?? "",
                                             child: Text(
                                               pago.organismo != null && pago.organismo!.length > 20
                                                   ? '${pago.organismo!.substring(0, 20)}...'
                                                   : pago.organismo ?? "-",
                                               overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black)
                                             ),
                                           ),
                                         ),
                                       ),

                                       // Monto orden ant
                                       DataCell(Text(pago.montoOrdenAnt?.toString() ?? "-", style: TextStyle(color: Colors.black))),

                                       // Beneficiario (con tooltip)
                                       DataCell(
                                         ConstrainedBox(
                                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.25),
                                           child: Tooltip(
                                             message: pago.beneficiario ?? "",
                                             child: Text(
                                               pago.beneficiario != null && pago.beneficiario!.length > 25
                                                   ? '${pago.beneficiario!.substring(0, 25)}...'
                                                   : pago.beneficiario ?? "-",
                                               overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black)
                                             ),
                                           ),
                                         ),
                                       ),

                                       // RIF
                                       DataCell(Text(pago.rif ?? "-" ,style: TextStyle(color: Colors.black))),

                                       // Desc. Unidad Administradora (con tooltip)
                                       DataCell(
                                         ConstrainedBox(
                                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.25),
                                           child: Tooltip(
                                             message: pago.descUnidadAdministradora ?? "",
                                             child: Text(
                                               pago.descUnidadAdministradora != null && pago.descUnidadAdministradora!.length > 25
                                                   ? '${pago.descUnidadAdministradora!.substring(0, 25)}...'
                                                   : pago.descUnidadAdministradora ?? "-",
                                               overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black)
                                             ),
                                           ),
                                         ),
                                       ),

                                       // Orden
                                       DataCell(Text(pago.orden?.toString() ?? "-",style: TextStyle(color: Colors.black))),

                                       // Denominacion (con tooltip)
                                       DataCell(
                                         ConstrainedBox(
                                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                                           child: Tooltip(
                                             message: pago.denominacion ?? "",
                                             child: Text(
                                               pago.denominacion != null && pago.denominacion!.length > 30
                                                   ? '${pago.denominacion!.substring(0, 30)}...'
                                                   : pago.denominacion ?? "-",
                                               overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black)
                                             ),
                                           ),
                                         ),
                                       ),

                                       // Cod. Unidad Administradora
                                       DataCell(Text(pago.codUnidadAdministradora ?? "-" ,style: TextStyle(color: Colors.black) )),

                                       // Fecha (formateada)
                                       DataCell(Text(controller.formatDate(pago.fechaPago?? "-"),style: TextStyle(color: Colors.black))),

                                       DataCell(
                                         ConstrainedBox(
                                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                                           child: Tooltip(
                                             message: pago.observacion ?? "",
                                             child: Text(
                                                 pago.observacion != null && pago.observacion!.length > 30
                                                     ? '${pago.observacion!.substring(0, 30)}...'
                                                     : pago.observacion ?? "-",
                                                 overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black)
                                             ),
                                           ),
                                         ),
                                       ),
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
