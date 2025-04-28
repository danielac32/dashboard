
import 'package:flutter/material.dart';

import '../../../infrastructure/entities/user.dart';
import 'avatar_widget.dart';
import 'text_drawer_dashboard.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.colors,
    required this.user,
  });

  final ColorScheme colors;
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.0,
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: colors.primary,

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarWidget(colors: colors,urlImage: ""),
            SizedBox(height: 10),
            TextDrawerDashboard(text: user.position!, colors: colors.onPrimary,size: 18),
            TextDrawerDashboard(text: user.email, colors: colors.onPrimary.withOpacity(0.7),size: 14),
            TextDrawerDashboard(text: user.name, colors: colors.onPrimary.withOpacity(0.7),size: 14),
          ],
        ),
      ),
    );
  }
}