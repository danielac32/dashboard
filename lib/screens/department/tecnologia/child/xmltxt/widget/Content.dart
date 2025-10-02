import 'package:flutter/material.dart';

import '../controller/Controller.dart';
import 'package:get/get.dart';

import 'EmptyState.dart';
import 'FilesList.dart';
import 'LoadingIndicator.dart';
import 'ResultsList.dart';

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.controller,
  });

  final XmlTxtController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return LoadingIndicator();
      } else if (controller.xmlFiles.isNotEmpty && controller.resultados.isEmpty) {
        return FilesList(controller: controller);
      } else if (controller.resultados.isNotEmpty) {
        return ResultsList(controller: controller);
      } else {
        return EmptyState();
      }
    });
  }
}