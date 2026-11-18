import 'package:colportando/features/workspace/domain/entities/workspace.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_dto.freezed.dart';
part 'workspace_dto.g.dart';

@freezed
abstract class WorkspaceClubDto with _$WorkspaceClubDto {
  // Constructor privado necesario para poder agregar métodos propios (toEntity).
  const WorkspaceClubDto._();

  const factory WorkspaceClubDto({
    required String tenantId,
    required String institutionId,
    required String institutionName,
    required String clubId,
    required String clubName,
    Map<String, dynamic>? membership,
    @Default([]) List<Map<String, dynamic>> roles,
    @Default([]) List<String> permissions,
    @Default([]) List<String> associateGroupIds,
  }) = _WorkspaceClubDto;

  // Se conecta la generación automática de fromJson y toJson.
  factory WorkspaceClubDto.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceClubDtoFromJson(json);

  // Convierte el DTO en la entidad pura del dominio.
  WorkspaceClub toEntity() => WorkspaceClub(
    tenantId: tenantId,
    institutionId: institutionId,
    institutionName: institutionName,
    clubId: clubId,
    clubName: clubName,
    membership: membership,
    roles: roles,
    permissions: permissions,
    associateGroupIds: associateGroupIds,
  );
}

@freezed
abstract class WorkspaceDto with _$WorkspaceDto {
  // Constructor privado necesario para poder agregar métodos propios (toEntity).
  const WorkspaceDto._();

  const factory WorkspaceDto({
    required String accountId,
    required String email,
    @Default([]) List<WorkspaceClubDto> clubs,
  }) = _WorkspaceDto;

  // Se conecta la generación automática de fromJson y toJson.
  factory WorkspaceDto.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceDtoFromJson(json);

  // Convierte el DTO en la entidad pura del dominio.
  Workspace toEntity() => Workspace(
    accountId: accountId,
    email: email,
    clubs: clubs.map((club) => club.toEntity()).toList(),
  );
}
