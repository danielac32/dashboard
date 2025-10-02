

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/Controller.dart';


class ButtonsWidget extends StatelessWidget {
  const ButtonsWidget({
    super.key,
    required this.controller,
  });

  final XmlTxtController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = controller;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [
          ElevatedButton(
            onPressed: ctrl.isLoading.value ? null : ctrl.subirArchivo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade800,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ctrl.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue,
                      ),
                    ),
                  )
                else
                  const Icon(Icons.search, size: 24),
                const SizedBox(width: 8),
                Text(
                  ctrl.isLoading.value ? 'Buscando...' : 'Abrir',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: ctrl.isLoading.value ? null : ctrl.consultarArchivos,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade800,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ctrl.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue,
                      ),
                    ),
                  )
                else
                  const Icon(Icons.verified, size: 24),
                const SizedBox(width: 8),
                Text(
                  ctrl.isLoading.value ? 'Buscando...' : 'Consultar XML',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: ctrl.xmlFiles.isEmpty || ctrl.isProcessing.value
                ? null
                : ctrl.procesarArchivos,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade50,
              foregroundColor: Colors.green.shade800,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.isProcessing.value)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.green,
                      ),
                    ),
                  )
                else
                  const Icon(Icons.cloud_upload, size: 24),
                const SizedBox(width: 8),
                Text(
                  controller.isProcessing.value
                      ? 'Procesando...'
                      : 'Procesar Archivos',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
