
import 'package:flutter/material.dart';

class ResumenGestionContent extends StatelessWidget {
  const ResumenGestionContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Resumen de Gestión',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildInfoCard(
                  context,
                  title: 'Indicadores Clave',
                  icon: Icons.assessment,
                  content: Column(
                    children: List.generate(4, (index) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.circle, size: 12),
                              const SizedBox(width: 8),
                              Text('Indicador ${index + 1}'),
                              const Spacer(),
                              Text('${75 + index * 5}%'),
                            ],
                          ),
                        ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  title: 'Metas Cumplidas',
                  icon: Icons.check_circle,
                  content: const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text('Meta 1')),
                      Chip(label: Text('Meta 2')),
                      Chip(label: Text('Meta 3')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
}