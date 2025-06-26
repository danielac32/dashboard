import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';


class DescargarWidget extends StatelessWidget {
  const DescargarWidget({
    super.key,
    required this.controller,
  });

  final PendienteController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        final isLoading = controller.cargando.value;
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(' ', style: TextStyle(fontSize: 12, color: Colors.grey)),

              if(isLoading) ...[
                  Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue,
                        ),
                      ),
                  )
              ] else...[
                  Tooltip(
                    message: 'Descargar reporte',
                    child: InkWell(
                      onTap: () async {
                        await controller.descargarReporte();
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1e3d7a),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )
              ],
            ]
        );
    });
  }
}
