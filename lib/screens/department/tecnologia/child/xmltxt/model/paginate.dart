class recaudacion {
  bool? success;
  List<Data>? data;
  Pagination? pagination;

  recaudacion({this.success, this.data, this.pagination});

  recaudacion.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Data {
  String? fechaRecaudacion;
  String? banco;
  int? estatus;

  Data({this.fechaRecaudacion, this.banco, this.estatus});

  Data.fromJson(Map<String, dynamic> json) {
    fechaRecaudacion = json['fecha_recaudacion'];
    banco = json['banco'];
    estatus = json['estatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fecha_recaudacion'] = this.fechaRecaudacion;
    data['banco'] = this.banco;
    data['estatus'] = this.estatus;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? pageSize;
  int? totalCount;
  int? totalPages;
  bool? hasPrevious;
  bool? hasNext;

  Pagination(
      {this.currentPage,
        this.pageSize,
        this.totalCount,
        this.totalPages,
        this.hasPrevious,
        this.hasNext});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalPages = json['totalPages'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['pageSize'] = this.pageSize;
    data['totalCount'] = this.totalCount;
    data['totalPages'] = this.totalPages;
    data['hasPrevious'] = this.hasPrevious;
    data['hasNext'] = this.hasNext;
    return data;
  }
}