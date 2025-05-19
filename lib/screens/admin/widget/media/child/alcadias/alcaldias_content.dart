
import 'package:flutter/material.dart';

class AlcaldiasContent extends StatelessWidget {
  const AlcaldiasContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Alcaldías Municipales',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text('Alcaldía ${index + 1}'),
                  subtitle: Text('Municipio ${index + 1}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navegar a detalle de alcaldía
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}