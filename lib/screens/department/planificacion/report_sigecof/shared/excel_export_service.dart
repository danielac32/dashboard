// excel_export_service.dart

import 'package:excel/excel.dart';


import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

class ExcelExportService {
  Future<void> exportToExcel({
    required String sheetName,
    required List<String> headers,
    required List<List<dynamic>> dataRows,
    required Map<int, double> columnWidths,
    required String fileNamePrefix,
  }) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel[sheetName];

      // Añadir encabezados
      sheet.appendRow(headers.cast<CellValue?>());

      // Añadir filas de datos
      for (var row in dataRows) {
        sheet.appendRow(row.map((cell) => cell.toString()).cast<CellValue?>().toList());
      }

      // Establecer anchos de columna
      columnWidths.forEach((colIndex, width) {
        sheet.setColumnWidth(colIndex, width);
      });

      // Codificar y descargar
      final bytes = excel.encode()!;
      final fileName = '$fileNamePrefix${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);

      Get.snackbar('Éxito', 'Reporte generado correctamente');
    } catch (e) {
      print('Error al generar Excel: $e');
      Get.snackbar('Error', 'No se pudo generar el archivo Excel');
    }
  }
}