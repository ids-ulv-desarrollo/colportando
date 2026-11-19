import 'package:equatable/equatable.dart';

// Resultado de crear una invitación: registro pendiente y su vencimiento.
class InvitationReceipt extends Equatable {
  final String invitationId;
  final String status;
  final DateTime expiresAt;
  // Indica que el servidor reconoció una repetición y devolvió el resultado original.
  final bool isReplayed;

  const InvitationReceipt({
    required this.invitationId,
    required this.status,
    required this.expiresAt,
    required this.isReplayed,
  });

  @override
  List<Object?> get props => [invitationId, status, expiresAt, isReplayed];
}

// Datos públicos de una invitación consultada con correo y código.
class InvitationPreview extends Equatable {
  final String invitationId;
  final String clubName;
  final String institutionName;
  final String emailHint;
  final DateTime expiresAt;

  const InvitationPreview({
    required this.invitationId,
    required this.clubName,
    required this.institutionName,
    required this.emailHint,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [
    invitationId,
    clubName,
    institutionName,
    emailHint,
    expiresAt,
  ];
}

// Resultado de aceptar una invitación: cuenta, persona y membresía registradas.
class InvitationAcceptance extends Equatable {
  final String accountId;
  final String personId;
  final String membershipId;
  final String membershipStatus;
  final String memberCondition;
  final bool isEmailVerified;
  // Indica que el servidor reconoció una repetición y devolvió el resultado original.
  final bool isReplayed;

  const InvitationAcceptance({
    required this.accountId,
    required this.personId,
    required this.membershipId,
    required this.membershipStatus,
    required this.memberCondition,
    required this.isEmailVerified,
    required this.isReplayed,
  });

  @override
  List<Object?> get props => [
    accountId,
    personId,
    membershipId,
    membershipStatus,
    memberCondition,
    isEmailVerified,
    isReplayed,
  ];
}
