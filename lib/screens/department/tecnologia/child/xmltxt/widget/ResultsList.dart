import 'package:flutter/material.dart';

import '../controller/Controller.dart';
import 'package:get/get.dart';

import 'ResultChip.dart';

class ResultsList extends StatelessWidget {
  const ResultsList({
    super.key,
    required this.controller,
  });

  final XmlTxtController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = controller;
      return Column(
        children: [
          Text(
            'Resultados del procesamiento',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: ctrl.resultados.length,
                  separatorBuilder: (_, __) => const Divider(height: 16),
                  itemBuilder: (_, index) {
                    final item = ctrl.resultados[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (item['errores'] as int) > 0
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            (item['errores'] as int) > 0
                                ? Icons.warning
                                : Icons.check_circle,
                            color: (item['errores'] as int) > 0
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                          ),
                        ),
                        title: Text(
                          item['archivo'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            children: [
                              ResultChip(text: '${item['planillas']} planillas', color: Colors.green.shade600),
                              const SizedBox(width: 10),
                              ResultChip(text: '${item['errores']} errores', color: (item['errores'] as int) > 0 ? Colors.red.shade600 : Colors.grey.shade600),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}