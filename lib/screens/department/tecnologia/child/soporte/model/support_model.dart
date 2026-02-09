class CreateSupport{
   final String name;
   final String description;
   final int userId;
   final String departamento;
   CreateSupport({required this.name,required this.description,required this.userId,required this.departamento});

   Map<String, dynamic> toMap() {
     return {
       'name': name,
       'description': description,
       'userId': userId,
       'departamento': departamento,
       //'status': status,
       //'startedAt': startedAt.toIso8601String(),
     };
   }
}

class UserSupport {

  final String name;
  final int supportCount;

  UserSupport({

    required this.name,
    required this.supportCount,
  });

  // Para crear desde JSON
  factory UserSupport.fromJson(Map<String, dynamic> json) {
    return UserSupport(

      name: json['name'],
      supportCount: json['supportCount'],
    );
  }

  // Para convertir a JSON
  Map<String, dynamic> toJson() {
    return {

      'name': name,
      'supportCount': supportCount,
    };
  }
}


class Autogenerate {
  List<Users>? users;

  Autogenerate({this.users});

  Autogenerate.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? name;
  int? supportCount;

  Users({this.name, this.supportCount});

  Users.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    supportCount = json['supportCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['supportCount'] = supportCount;
    return data;
  }
}