import 'package:colportando/features/auth/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
abstract class UserDto with _$UserDto {
  // Constructor privado necesario para poder agregar métodos propios (toEntity).
  const UserDto._();

  const factory UserDto({
    required String accountId,
    required String email,
    required String status,
    required String sessionId,
  }) = _UserDto;

  // Se conecta la generación automática de fromJson y toJson.
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  // Convierte el DTO en la entidad pura del dominio.
  User toEntity() => User(
    accountId: accountId,
    email: email,
    status: status,
    sessionId: sessionId,
  );
}
