
import 'package:core_system/screens/admin/widget/media/child/resumen/widget/resumen_preview.dart';
import 'package:core_system/screens/admin/widget/media/child/resumen/widget/resumen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/resumen_controller.dart';






class ResumenGestionContent extends StatelessWidget {
  const ResumenGestionContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ResumenController controller = Get.put(ResumenController());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            // Sección 1: Subir nuevas imágenes
            ResumenView1(controller: controller, theme: theme),

            const SizedBox(height: 20),
            ResumenPreview(controller: controller,),
          ],
        ),
      ),
    );
  }
}


