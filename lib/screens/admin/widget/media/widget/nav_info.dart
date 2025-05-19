import 'package:flutter/material.dart';

class NavInfo extends StatelessWidget {
  const NavInfo({
    super.key,
    required this.colorScheme,
    required this.theme,
  });

  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.library_books,
            color: colorScheme.onPrimaryContainer,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'Contenido Multimedia',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}