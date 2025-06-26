import 'package:flutter/material.dart';

import '../../../../../core/utils/get_name.dart';
import '../controller/media_controller.dart';


class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    super.key,
    required this.colorScheme,
    required this.theme,
    required this.mediaController,
  });

  final ColorScheme colorScheme;
  final ThemeData theme;
  final MediaController mediaController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.primary,
      ),
      labelColor: colorScheme.onPrimary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      tabs: mediaController.items.map((item) {
        return Tab(
          height: 40,
          text: getDisplayName(item),
        );
      }).toList(),
    );
  }
}