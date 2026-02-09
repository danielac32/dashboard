// controllers/report_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/shared/alert.dart';
import '../model/model.dart';

class ReportController extends GetxController {
  var isLoading = false.obs;
  var reports = <Report>[].obs;
  var filteredReports = <Report>[].obs;
  var searchQuery = ''.obs;
  var selectedStatus = 'Todos'.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  void loadReports() {
    isLoading.value = true;

    // Datos de ejemplo
    final mockReports = [
      Report(
        id: '1',
        title: 'Solicitud de Contratación',
        description: 'Formulario para solicitar nuevo personal',
        fileName: 'solicitud_contratacion.pdf',
        fileSize: '2.5 MB',
        date: DateTime.now().subtract(Duration(days: 2)),
        status: 'Disponible',
      ),
      Report(
        id: '2',
        title: 'Evaluación de Desempeño',
        description: 'Planilla de evaluación trimestral',
        fileName: 'evaluacion_desempeno.docx',
        fileSize: '1.8 MB',
        date: DateTime.now().subtract(Duration(days: 5)),
        status: 'Disponible',
      ),
      Report(
        id: '3',
        title: 'Vacaciones y Permisos',
        description: 'Solicitud de días libres',
        fileName: 'solicitud_vacaciones.pdf',
        fileSize: '1.2 MB',
        date: DateTime.now().subtract(Duration(days: 7)),
        status: 'En revisión',
      ),
      Report(
        id: '4',
        title: 'Nómina y Salarios',
        description: 'Reporte mensual de nómina',
        fileName: 'reporte_nomina.xlsx',
        fileSize: '3.1 MB',
        date: DateTime.now().subtract(Duration(days: 10)),
        status: 'Disponible',
      ),
    ];

    reports.assignAll(mockReports);
    filteredReports.assignAll(mockReports);
    isLoading.value = false;
  }

  void filterReports() {
    if (searchQuery.isEmpty && selectedStatus.value == 'Todos') {
      filteredReports.assignAll(reports);
    } else {
      filteredReports.assignAll(reports.where((report) {
        final matchesSearch = report.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            report.description.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesStatus = selectedStatus.value == 'Todos' ||
            report.status == selectedStatus.value;
        return matchesSearch && matchesStatus;
      }).toList());
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterReports();
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    filterReports();
  }

  Future<void> downloadReport(Report report) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    SnackbarAlert.success(message: "Descarga exitosa");
    isLoading.value = false;
  }

  void refreshReports() {
    loadReports();
  }
}