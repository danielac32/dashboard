
class AvailableReports {
  List<String>? availableReports;

  AvailableReports({this.availableReports});

  AvailableReports.fromJson(Map<String, dynamic> json) {
    availableReports = json['availableReports'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['availableReports'] = availableReports;
    return data;
  }
}
