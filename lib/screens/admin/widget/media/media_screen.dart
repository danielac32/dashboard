import 'package:core_system/screens/admin/widget/media/service/media_service.dart';
import 'package:core_system/screens/admin/widget/media/widget/nav_info.dart';
import 'package:core_system/screens/admin/widget/media/widget/section_content_tab.dart';
import 'package:core_system/screens/admin/widget/media/widget/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/media_controller.dart';





class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaController = Get.put(MediaController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      if (mediaController.items.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return SingleChildScrollView(
        child: Column(

          children: [
            // Encabezado moderno
           // NavInfo(colorScheme: colorScheme, theme: theme),
            const SizedBox(height: 16),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.surfaceVariant.withOpacity(0.3),
              ),
              child: DefaultTabController(
                length: mediaController.items.length,
                child: Column(
                  children: [
                    TabBarWidget(colorScheme: colorScheme, theme: theme, mediaController: mediaController),
                    const SizedBox(height: 5),
                    // Contenido de las pestañas
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.95,
                      //width: MediaQuery.of(context).size.width * 0.8,
                      child: TabBarView(
                        children: mediaController.items.map((item) {
                          return SectionContent(sectionKey: item);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

