import 'package:flutter/material.dart';

import '../../../../../core/utils/get_name.dart';
import '../section_config/section_config.dart';

class SectionContent extends StatelessWidget {
  const SectionContent({super.key, required this.sectionKey});

  final String sectionKey;

  @override
  Widget build(BuildContext context) {
    registerAppSections();
    final config = SectionManager.getSection(sectionKey);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (config == null) {
      return _buildDefaultContent(context, sectionKey);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surface,
        child: config.builder(context),
      ),
    );
  }

  Widget _buildDefaultContent(BuildContext context, String sectionKey) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            "Sección '${getDisplayName(sectionKey)}' no configurada",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}