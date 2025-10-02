import 'package:flutter/material.dart';

import '../controller/Controller.dart';
import 'package:get/get.dart';

import 'TotalItemWidget.dart';

class TotalsCard extends StatelessWidget {
  const TotalsCard({
    super.key,
    required this.controller,
  });

  final XmlTxtController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = controller;
      return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade600,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TotalItemWidget(label: 'Total Planillas', value: ctrl.totalPlanillas.toString(), icon: Icons.list_alt, color: Colors.white),
            Container(
              width: 1,
              height: 50,
              color: Colors.white.withOpacity(0.3),
            ),
            TotalItemWidget(label: 'Total Errores', value: ctrl.totalErrores.toString(), icon: Icons.warning, color: ctrl.totalErrores.value > 0
                ? Colors.orange.shade200
                : Colors.white),
          ],
        ),
      );
    });
  }
}