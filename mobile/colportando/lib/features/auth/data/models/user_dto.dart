import 'package:colportando/features/auth/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
abstract class UserDto with _$UserDto {
  // Constructor privado necesario para poder agregar métodos propios (toEntity).
  const UserDto._();

  const factory UserDto({
    required String id,
    required String name,
    required String email,
    String? role,
    String? status,
    String? token,
    // Con @JsonKey se le indica al formateador de json que el nombre de la propiedad en el json es "created_at", pero en Dart es "createdAt".
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "deleted_at") DateTime? deletedAt,
  }) = _UserDto;

  // Se conecta la generación automática de fromJson y toJson.
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  // Convierte el DTO en la entidad pura del dominio.
  User toEntity() => User(
    id: id,
    name: name,
    email: email,
    role: role,
    status: status,
    token: token,
    createdAt: createdAt,
    deletedAt: deletedAt,
  );
}
