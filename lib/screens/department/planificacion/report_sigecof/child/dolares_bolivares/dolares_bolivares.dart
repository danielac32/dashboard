
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/config/theme/app_theme.dart';
import '../../../../shared_widget/date.dart';
import '../../../../shared_widget/generic_consult.dart';
import '../../../../shared_widget/generic_download.dart';
import 'controller/controller.dart';


class DolaresBolivares extends StatelessWidget {
   DolaresBolivares({super.key});
  final controller = Get.put(DolarBolivarController());
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
                 color: Colors.black12,//Colors.white,
                 borderRadius: BorderRadius.circular(8),
                 boxShadow: [
                   BoxShadow(
                     color: AppTheme.goldColor.withOpacity(0.1),//Colors.grey.withOpacity(0.1),
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
                       await controller.cargar(
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
                                 columnSpacing: 8, // Reducir este valor
                                 horizontalMargin: 8, // Reducir este valor
                                 showCheckboxColumn: false,
                                 dataRowColor: WidgetStateProperty.all(Colors.white),
                                 headingRowColor: WidgetStateProperty.all(AppTheme.goldColor),
                                 columns: const [
                                   DataColumn(label: Text("Año", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Estado", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Estado 2", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Pagada", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Orden", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Monto Pagado", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Organismo", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Beneficiario", style: TextStyle(color: Colors.black))),
                                   DataColumn(label: Text("Observación", style: TextStyle(color: Colors.black))),
                                 ],
                                 rows: controller.paginatedResults.map((dolarbolivar) {
                                   return DataRow(
                                     cells: [
                                       DataCell(Text(dolarbolivar.anho.toString(), style: TextStyle(color: Colors.black))),
                                       DataCell(Text(dolarbolivar.estado.toString(), style: TextStyle(color: Colors.black))),
                                       DataCell(Text(dolarbolivar.estado2.toString(), style: TextStyle(color: Colors.black))),
                                       DataCell(Text(controller.formatDate(dolarbolivar.pagada), style: TextStyle(color: Colors.black))),
                                       DataCell(Text(dolarbolivar.orden.toString(), style: TextStyle(color: Colors.black))),
                                       DataCell(Text('\$${dolarbolivar.montoPagado.toStringAsFixed(2)}', style: TextStyle(color: Colors.black))),
                                       DataCell(
                                         ConstrainedBox(
                                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.2),
                                           child: Tooltip(
                                             message: dolarbolivar.organismo,
                                             child: Text(
                                               dolarbolivar.organismo.length > 20
                                                   ? '${dolarbolivar.organismo.substring(0, 20)}...'
                                                   : dolarbolivar.organismo,
                                               overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black)
                                             ),
                                           ),
                                         ),
                                       ),
                                       DataCell(
                                         ConstrainedBox(
                                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.2),
                                           child: Tooltip(
                                             message: dolarbolivar.beneficiario,
                                             child: Text(
                                               dolarbolivar.beneficiario.length > 20
                                                   ? '${dolarbolivar.beneficiario.substring(0, 20)}...'
                                                   : dolarbolivar.beneficiario,
                                               overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black)
                                             ),
                                           ),
                                         ),
                                       ),
                                       DataCell(
                                         ConstrainedBox(
                                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                                           child: Tooltip(
                                             message: dolarbolivar.observacion,
                                             child: Text(
                                               dolarbolivar.observacion.length > 30
                                                   ? '${dolarbolivar.observacion.substring(0, 30)}...'
                                                   : dolarbolivar.observacion,
                                               overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black)
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

