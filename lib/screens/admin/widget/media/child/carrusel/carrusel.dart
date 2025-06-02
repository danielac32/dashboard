

import 'package:core_system/screens/admin/widget/media/child/carrusel/widget/carrusel_preview.dart';
import 'package:core_system/screens/admin/widget/media/child/carrusel/widget/carrusel_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/carrusel_controller.dart';


class CarruselContent extends StatelessWidget {
  final CarruselController controller = Get.put(CarruselController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            // Sección 1: Subir nuevas imágenes
            CarruselView1(controller: controller, theme: theme),

            const SizedBox(height: 20),
            CarruselPreview(controller: controller,),
          ],
        ),
      ),
    );
  }
}





