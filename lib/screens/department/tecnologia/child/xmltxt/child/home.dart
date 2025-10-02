
import 'package:flutter/material.dart';

import '../controller/Controller.dart';
import 'package:get/get.dart';

import '../widget/Content.dart';
import '../widget/TotalItemWidget.dart';
import '../widget/TotalsCard.dart';
import '../widget/buttons.dart';
import '../widget/header.dart';



class XmlTxtUploadView extends StatelessWidget {
  XmlTxtUploadView({super.key});
  final controller = Get.put(XmlTxtController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header
              HeaderWidget(),
              const SizedBox(height: 24),

              // Botones
              ButtonsWidget(controller: controller),
              const SizedBox(height: 32),

              // Contenido
              Expanded(
                child: Content(controller: controller),
              ),

              // Totales (solo se muestra después de procesar)
              Obx(() {
                if (controller.resultados.isNotEmpty) {
                  return TotalsCard(controller: controller);
                } else {
                  return const SizedBox(); // No mostrar si no hay resultados
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}














