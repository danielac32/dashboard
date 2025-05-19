

import 'package:flutter/material.dart';


class ProgramacionFinancieraContent extends StatelessWidget {
  const ProgramacionFinancieraContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Programación Financiera',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Año')),
                  DataColumn(label: Text('Presupuesto')),
                  DataColumn(label: Text('Ejecutado')),
                ],
                rows: List.generate(5, (index) {
                  final year = 2023 - index;
                  return DataRow(
                    cells: [
                      DataCell(Text(year.toString())),
                      DataCell(Text('\$${(1000000 - index * 100000).toStringAsFixed(2)}')),
                      DataCell(Text('\$${(800000 - index * 80000).toStringAsFixed(2)}')),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}