import 'package:equatable/equatable.dart';

// Entidad que representa a un participante en el resumen del grupo.
class GroupParticipant extends Equatable {
  final String participationId;
  final String membershipId;

  const GroupParticipant({
    required this.participationId,
    required this.membershipId,
  });

  @override
  List<Object?> get props => [participationId, membershipId];
}

// Entidad que representa a un campo territorial asignado al grupo.
class GroupField extends Equatable {
  final String fieldId;
  final String name;

  const GroupField({
    required this.fieldId,
    required this.name,
  });

  @override
  List<Object?> get props => [fieldId, name];
}

// Entidad que representa el resumen operativo completo de un grupo de campaña.
class GroupOverview extends Equatable {
  final String groupId;
  final String campaignId;
  final String name;
  final String? associateParticipationId;
  final List<GroupParticipant> participants;
  final List<GroupField> fields;

  const GroupOverview({
    required this.groupId,
    required this.campaignId,
    required this.name,
    this.associateParticipationId,
    this.participants = const [],
    this.fields = const [],
  });

  @override
  List<Object?> get props => [
    groupId,
    campaignId,
    name,
    associateParticipationId,
    participants,
    fields,
  ];
}
