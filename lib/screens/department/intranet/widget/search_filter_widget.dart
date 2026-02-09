
// widgets/search_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';

class SearchFilterWidget extends StatelessWidget {
  final ReportController controller;

   SearchFilterWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra de búsqueda
          TextField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Buscar reportes...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          SizedBox(height: 12),

          // Filtro por estado
          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedStatus.value,
            items: ['Todos', 'Disponible', 'En revisión', 'Pendiente']
                .map((status) => DropdownMenuItem(
              value: status,
              child: Text(status),
            ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.setStatusFilter(value);
              }
            },
            decoration: InputDecoration(
              labelText: 'Filtrar por estado',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          )),
        ],
      ),
    );
  }
}