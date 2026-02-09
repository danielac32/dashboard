
import 'package:core_system/screens/department/intranet/widget/report_card.dart';
import 'package:core_system/screens/department/intranet/widget/search_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/controller.dart';

class Intranet extends StatelessWidget {
  final ReportController _controller = Get.put(ReportController());

  Intranet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sistema de Reportes RRHH',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _controller.refreshReports,
            tooltip: 'Actualizar reportes',
          ),
        ],
      ),
      body: Column(
        children: [
          // Widget de búsqueda y filtros
          SearchFilterWidget(controller: _controller),

          // Contador de resultados
          Obx(() => _buildResultsCounter()),

          // Lista de reportes
          Expanded(
            child: _buildReportsList(),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _buildResultsCounter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        '${_controller.filteredReports.length} reportes encontrados',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando reportes...'),
            ],
          ),
        );
      }

      if (_controller.filteredReports.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'No se encontraron reportes',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Intenta con otros términos de búsqueda',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          _controller.refreshReports();
        },
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: _controller.filteredReports.length,
          itemBuilder: (context, index) {
            final report = _controller.filteredReports[index];
            return ReportCard(
              report: report,
              onDownload: () => _controller.downloadReport(report),
            );
          },
        ),
      );
    });
  }
}