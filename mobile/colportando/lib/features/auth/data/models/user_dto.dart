import 'package:colportando/features/auth/domain/entities/user.dart';

class UserDto extends User {
  const UserDto({
    required super.id,
    required super.name,
    required super.email,
    super.role,
    super.status,
    super.token,
    required super.createdAt,
    super.deletedAt,
  });

  // Convierte el formato json en objetos de Dart, y los convierte en entidades (clases).
  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json["id"].toString(),
    name: json["name"].toString(),
    email: json["email"].toString(),
    role: json["role"]?.toString(),
    status: json["status"]?.toString(),
    token: json["token"]?.toString(),
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"].toString())
        : DateTime.now(),
    deletedAt: json["deleted_at"] == null
        ? null
        : DateTime.parse(json["deleted_at"].toString()),
  );
}

// Esto devuelve en formato json, lo que significa que se puede enviar al backend para guardarlo (hasta que se sincronice mediante el internet).
// User toEntity({taskSyncStatus status = taskSyncStatus.synced})
//     {
      
//     }