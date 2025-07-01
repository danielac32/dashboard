import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../../../../core/config/theme/app_theme.dart';
import '../controller/controller.dart';

class DesdeWidget extends StatelessWidget {
  const DesdeWidget({
    super.key,
    required this.controller,
  });

  final DolarBolivarController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.cargando.value;

      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Desde',
              style: TextStyle(fontSize: 12, color: AppTheme.goldColor),
            ),
            const SizedBox(height: 4),
            Stack(
              children: [
                SizedBox(
                  height: 40,
                  child: InkWell(
                    onTap: isLoading
                        ? null
                        : () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: controller.fechaDesde.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        controller.fechaDesde.value = date;
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        filled: isLoading,
                        fillColor: AppTheme.goldColor.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy').format(controller.fechaDesde.value),
                            style: TextStyle(
                              color: isLoading ? Colors.white : AppTheme.goldColor,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: isLoading ? Colors.white : AppTheme.goldColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
           /* if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Cargando datos...',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),*/
          ],
        ),
      );
    });
  }
}