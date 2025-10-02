import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/config/theme/app_theme.dart';
import '../../../../shared_widget/date.dart';
import '../../../../shared_widget/generic_consult.dart';
import '../../../../shared_widget/generic_download.dart';
import 'controller/controller.dart';



class Retencion extends StatelessWidget {
    Retencion({super.key});
    final controller = Get.put(RetencionController());


    @override
    Widget build(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                      },
                      isLoading: controller.cargando.value,
                      label: 'Desde',
                    )),
                    const SizedBox(width: 8),
                    Obx(() => GenericDatePickerField(
                      initialDate: controller.fechaHasta.value,
                      onDateSelected: (date) {
                        controller.fechaHasta.value = date;
                      },
                      isLoading: controller.cargando.value,
                      label: 'Hasta',
                      primaryColor: AppTheme.goldColor,
                    )),
                    const SizedBox(width: 12),
                    Obx(() => GenericConsultButton(
                      isLoading: controller.cargando.value,
                      onConsult: () async {
                        await controller.cargarRetencion(
                          controller.fechaDesde.value,
                          controller.fechaHasta.value,
                        );
                      },
                    )),
                    const SizedBox(width: 12),
                    Obx(() => controller.jsonDataAlmacenado.isNotEmpty
                        ? GenericDownloadButton(
                      isLoading: controller.cargando.value,
                      onDownload: () async {
                        await controller.descargarReporte();
                      },
                    )
                        : const SizedBox())
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

                  if (controller.jsonDataAlmacenado.isEmpty) {
                    return const Center(
                      child: Text(
                        "No hay registros para mostrar",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  // Aquí mostramos el mensaje cuando hay resultados
                  return SingleChildScrollView(
                    child: Center(
                      child: Container(
                        height: screenHeight * 1.5, // Hace el contenedor más alto que la pantalla
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.3), // 40% de espacio vacío
                            // Tu contenido del mensaje aquí
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green, width: 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "¡Su reporte ha sido generado!",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Ya puede descargar el comprobante de retención",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green[700],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await controller.descargarReporte();
                                    },
                                    icon: const Icon(Icons.download),
                                    label: const Text("Descargar Reporte"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.goldColor,
                                      foregroundColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      );
    }
}