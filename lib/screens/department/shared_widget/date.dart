import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GenericDatePickerField extends StatelessWidget {
  /// Fecha actual mostrada
  final DateTime initialDate;

  /// Acción a ejecutar cuando se selecciona una nueva fecha
  final void Function(DateTime) onDateSelected;

  /// Indica si está cargando (deshabilita selección)
  final bool isLoading;

  /// Etiqueta del campo (por ejemplo: 'Desde', 'Hasta', etc.)
  final String label;

  /// Color principal del campo (opcional)
  final Color? primaryColor;

  const GenericDatePickerField({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    required this.isLoading,
    this.label = 'Fecha',
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? Theme.of(context).primaryColor;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
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
                      initialDate: initialDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      onDateSelected(date);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      filled: isLoading,
                      fillColor: color.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(initialDate),
                          style: TextStyle(
                            color: isLoading ? Colors.white : color,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: isLoading ? Colors.white : color,
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
        ],
      ),
    );
  }
}

/*
GenericDatePickerField(
  initialDate: miOtroController.fechaDesde.value,
  onDateSelected: (date) {
    miOtroController.fechaDesde.value = date;
    // Puedes llamar a cualquier función adicional aquí
  },
  isLoading: miOtroController.cargando.value,
  label: 'Desde',
)


GenericDatePickerField(
  initialDate: miOtroController.fechaHasta.value,
  onDateSelected: (date) {
    miOtroController.fechaHasta.value = date;
  },
  isLoading: miOtroController.cargando.value,
  label: 'Hasta',
  primaryColor: Colors.green,
)


 */