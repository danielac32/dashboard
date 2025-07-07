import 'package:flutter/material.dart';

import '../../../core/config/theme/app_theme.dart';
import '../../../core/utils/constants.dart';
import '../../../infrastructure/shared/constants.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.colors, required this.urlImage,
  });


  final ColorScheme colors;
  final String urlImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage("${AppStrings.urlApi}/avatar/"/*DefaultUrl.avatarUrl*/),//AssetImage('assets/1.jpeg'),
      radius: 30,
      backgroundColor: AppTheme.goldColor,
      //child: Icon(Icons.person, size: 40, color: colors.onSecondary),
    );
  }
}