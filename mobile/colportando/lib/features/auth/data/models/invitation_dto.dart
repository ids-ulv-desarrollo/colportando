import 'package:colportando/features/auth/domain/entities/invitation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invitation_dto.freezed.dart';
part 'invitation_dto.g.dart';

// Respuesta de POST /auth/invitations (202 creada o 200 repetición reconocida).
@freezed
abstract class InvitationReceiptDto with _$InvitationReceiptDto {
  // Constructor privado necesario para poder agregar métodos propios.
  const InvitationReceiptDto._();

  const factory InvitationReceiptDto({
    required String invitationId,
    required String status,
    required DateTime expiresAt,
    @JsonKey(name: "replayed") required bool isReplayed,
  }) = _InvitationReceiptDto;

  // Se conecta la generación automática de fromJson y toJson.
  factory InvitationReceiptDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationReceiptDtoFromJson(json);

  // Reconstruye el DTO desde la entidad para el Map de compatibilidad de la demo.
  factory InvitationReceiptDto.fromEntity(InvitationReceipt receipt) =>
      InvitationReceiptDto(
        invitationId: receipt.invitationId,
        status: receipt.status,
        expiresAt: receipt.expiresAt,
        isReplayed: receipt.isReplayed,
      );

  // Convierte el DTO en la entidad pura del dominio.
  InvitationReceipt toEntity() => InvitationReceipt(
    invitationId: invitationId,
    status: status,
    expiresAt: expiresAt,
    isReplayed: isReplayed,
  );
}

// Respuesta de POST /auth/invitations/inspect.
@freezed
abstract class InvitationPreviewDto with _$InvitationPreviewDto {
  // Constructor privado necesario para poder agregar métodos propios.
  const InvitationPreviewDto._();

  const factory InvitationPreviewDto({
    required String invitationId,
    required String clubName,
    required String institutionName,
    required String emailHint,
    required DateTime expiresAt,
  }) = _InvitationPreviewDto;

  // Se conecta la generación automática de fromJson y toJson.
  factory InvitationPreviewDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationPreviewDtoFromJson(json);

  // Reconstruye el DTO desde la entidad para el Map de compatibilidad de la demo.
  factory InvitationPreviewDto.fromEntity(InvitationPreview preview) =>
      InvitationPreviewDto(
        invitationId: preview.invitationId,
        clubName: preview.clubName,
        institutionName: preview.institutionName,
        emailHint: preview.emailHint,
        expiresAt: preview.expiresAt,
      );

  // Convierte el DTO en la entidad pura del dominio.
  InvitationPreview toEntity() => InvitationPreview(
    invitationId: invitationId,
    clubName: clubName,
    institutionName: institutionName,
    emailHint: emailHint,
    expiresAt: expiresAt,
  );
}

// Respuesta de POST /auth/invitations/accept (201 creada o 200 repetición reconocida).
@freezed
abstract class InvitationAcceptanceDto with _$InvitationAcceptanceDto {
  // Constructor privado necesario para poder agregar métodos propios.
  const InvitationAcceptanceDto._();

  const factory InvitationAcceptanceDto({
    required String accountId,
    required String personId,
    required String membershipId,
    required String membershipStatus,
    required String memberCondition,
    @JsonKey(name: "emailVerified") required bool isEmailVerified,
    @JsonKey(name: "replayed") required bool isReplayed,
  }) = _InvitationAcceptanceDto;

  // Se conecta la generación automática de fromJson y toJson.
  factory InvitationAcceptanceDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationAcceptanceDtoFromJson(json);

  // Reconstruye el DTO desde la entidad para el Map de compatibilidad de la demo.
  factory InvitationAcceptanceDto.fromEntity(InvitationAcceptance acceptance) =>
      InvitationAcceptanceDto(
        accountId: acceptance.accountId,
        personId: acceptance.personId,
        membershipId: acceptance.membershipId,
        membershipStatus: acceptance.membershipStatus,
        memberCondition: acceptance.memberCondition,
        isEmailVerified: acceptance.isEmailVerified,
        isReplayed: acceptance.isReplayed,
      );

  // Convierte el DTO en la entidad pura del dominio.
  InvitationAcceptance toEntity() => InvitationAcceptance(
    accountId: accountId,
    personId: personId,
    membershipId: membershipId,
    membershipStatus: membershipStatus,
    memberCondition: memberCondition,
    isEmailVerified: isEmailVerified,
    isReplayed: isReplayed,
  );
}
