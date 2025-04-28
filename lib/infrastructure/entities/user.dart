

//import 'enum.dart';
class UserEntity {
  final int id;
  final String name;
  final String email;
  final bool isActive;
  final String rol;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? department; // Departamento (puede ser nulo)
  final String? profileImage; // Imagen de perfil (puede ser nulo)
  final String? position; // Cargo (puede ser nulo)

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.isActive = true,
    this.rol = 'USER',//Role.USER.label,//'user',
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    this.department,
    this.profileImage,
    this.position,
  });

  // Método para crear una copia del usuario con algunos campos modificados
  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    bool? isActive,
    String? rol,
    String? password,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? department,
    String? profileImage,
    String? position,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      rol: rol ?? this.rol,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      department: department ?? this.department,
      profileImage: profileImage ?? this.profileImage,
      position: position ?? this.position,
    );
  }

  // Método para convertir el objeto a un mapa (útil para persistencia)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isActive': isActive,
      'rol': rol,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'department': department,
      'profileImage': profileImage,
      'position': position,
    };
  }

  // Factory method para crear un UserEntity desde un mapa
  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      isActive: map['isActive'] as bool,
      rol: map['rol'] as String,
      password: map['password'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      department: map['department'] as String?,
      profileImage: map['profileImage'] as String?,
      position: map['position'] as String?,
    );
  }

  @override
  String toString() {
    return 'UserEntity{id: $id, name: $name, email: $email, isActive: $isActive, rol: $rol, password: ****, createdAt: $createdAt, updatedAt: $updatedAt, department: $department, profileImage: $profileImage, position: $position}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              email == other.email &&
              isActive == other.isActive &&
              rol == other.rol &&
              password == other.password &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt &&
              department == other.department &&
              profileImage == other.profileImage &&
              position == other.position;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      isActive.hashCode ^
      rol.hashCode ^
      password.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      department.hashCode ^
      profileImage.hashCode ^
      position.hashCode;
}

/*
1. Crear una instancia de UserEntity
final newUser = UserEntity(
  id: 1,
  name: 'Juan Pérez',
  email: 'juan@example.com',
  password: 'contraseñaSegura123',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  department: 'Ventas',
  profileImage: 'https://example.com/profile.jpg',
  position: 'Gerente de Ventas',
);

2. Crear un usuario con valores por defecto
final defaultUser = UserEntity(
  id: 2,
  name: 'María García',
  email: 'maria@example.com',
  password: 'otraContraseña',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
// isActive será true y rol será 'user' por defecto
3. Modificar un usuario existente (usando copyWith)
final updatedUser = newUser.copyWith(
  name: 'Juan Carlos Pérez', // Cambiamos el nombre
  position: 'Director de Ventas', // Actualizamos el cargo
  updatedAt: DateTime.now(), // Actualizamos la fecha de modificación
);

4. Convertir a Map (para guardar en base de datos o enviar a API)

final userMap = newUser.toMap();
print(userMap);
5. Crear UserEntity desde un Map (para recibir de API o base de datos)
final userData = {
  'id': 3,
  'name': 'Ana López',
  'email': 'ana@example.com',
  'isActive': true,
  'rol': 'admin',
  'password': 'admin123',
  'createdAt': '2023-05-15T10:00:00Z',
  'updatedAt': '2023-05-20T15:30:00Z',
  'department': 'TI',
  'profileImage': 'https://example.com/ana.jpg',
  'position': 'Administradora de Sistemas',
};

final userFromMap = UserEntity.fromMap(userData);
6. Uso en Flutter (ejemplo con ListView)
class UserList extends StatelessWidget {
  final List<UserEntity> users;

  const UserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: user.profileImage != null
              ? CircleAvatar(backgroundImage: NetworkImage(user.profileImage!))
              : const CircleAvatar(child: Icon(Icons.person)),
          title: Text(user.name),
          subtitle: Text('${user.position ?? 'Sin cargo'} - ${user.department ?? 'Sin departamento'}'),
          trailing: Text(user.rol),
        );
      },
    );
  }
}




 */