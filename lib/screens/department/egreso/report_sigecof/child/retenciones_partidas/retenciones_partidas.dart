

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../../../core/config/theme/app_theme.dart';
import '../../../../shared_widget/date.dart';
import '../../../../shared_widget/generic_consult.dart';
import '../../../../shared_widget/generic_download.dart';
import 'controller/controller.dart';



class RetencionesPartidas extends StatelessWidget {
  RetencionesPartidas({super.key});
  final controller = Get.put(EgresoRetencionesPartidasController());
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
                      await controller.cargarRetencionesPartidas(
                        controller.fechaDesde.value,
                        controller.fechaHasta.value,
                      );
                    },
                  )),

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
                return const Center();

              }),
            )
          ],
        ),
      ),
    );
  }
}
