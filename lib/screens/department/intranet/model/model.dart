
// models/report_model.dart
class Report {
  final String id;
  final String title;
  final String description;
  final String fileName;
  final String fileSize;
  final DateTime date;
  final String status;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.fileName,
    required this.fileSize,
    required this.date,
    required this.status,
  });
}