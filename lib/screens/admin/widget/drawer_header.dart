
import 'package:flutter/material.dart';

import '../../../core/config/theme/app_theme.dart';
import '../../../infrastructure/entities/user.dart';
import '../../../infrastructure/entities/user_response.dart';
import 'avatar_widget.dart';
import 'text_drawer_dashboard.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.colors,
    required this.user,
  });

  final ColorScheme colors;
  final User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.0,
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: AppTheme.goldColor,

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarWidget(colors: colors,urlImage: ""),
            SizedBox(height: 10),
            TextDrawerDashboard(text: user.position!, colors: Colors.black/*colors.onPrimary*/,size: 18),
            TextDrawerDashboard(text: user.email!, colors: Colors.black.withOpacity(0.7)/*colors.onPrimary.withOpacity(0.7)*/,size: 14),
            TextDrawerDashboard(text: user.name!, colors: Colors.black.withOpacity(0.7)/*colors.onPrimary.withOpacity(0.7)*/,size: 14),
          ],
        ),
      ),
    );
  }
}