
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label centrado
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),

        // Dropdown contenedor
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value.isEmpty ? null : value,
              hint: Center(
                child: Text(
                  value.isEmpty ? "-- Seleccionar --" : value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              icon: Icon(
                Icons.arrow_drop_down_rounded,
                color: const Color(0xFF1e3d7a),
                size: 28,
              ),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),

              // 👇 Aquí mostramos siempre el valor seleccionado
              selectedItemBuilder: (context) {
                return items.map((item) {
                  return Center(
                    child: Text(
                      _getDisplayText(item),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList();
              },

              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  onTap: () {},
                  enabled: item.isNotEmpty,
                  child: Center(
                    child: Text(
                      _getDisplayText(item),
                      style: TextStyle(
                        fontWeight: item == value ? FontWeight.bold : FontWeight.normal,
                        color: item == value ? const Color(0xFF1e3d7a) : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),

              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  String _getDisplayText(String item) {
    if (item.isEmpty) {
      return "-- Seleccionar --";
    } else if (item == 'pendientes') {
      return "pendientes";
    } else if (item == 'pagadas') {
      return "pagadas";
    } else if (item == 'retenciones') {
      return "Pagadas con Retenciones";
    }
    return item;
  }
}
