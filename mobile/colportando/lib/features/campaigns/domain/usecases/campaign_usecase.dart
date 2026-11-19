import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/campaigns/domain/entities/group_overview.dart';
import 'package:colportando/features/campaigns/domain/repositories/campaign_repository.dart';

// crea una nueva campaña para el club.
class CreateCampaignUsecase {
  final ICampaignRepository repository;
  const CreateCampaignUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String clubId,
    required String name,
    required String startsOn,
    required String endsOn,
    String? description,
  }) => repository.createCampaign(
    clubId: clubId,
    name: name,
    startsOn: startsOn,
    endsOn: endsOn,
    description: description,
  );
}

// activa, cierra o cancela una campaña.
class ChangeCampaignStatusUsecase {
  final ICampaignRepository repository;
  const ChangeCampaignStatusUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String campaignId,
    required String status,
  }) => repository.changeCampaignStatus(campaignId: campaignId, status: status);
}

// crea un grupo de trabajo dentro de una campaña.
class CreateCampaignGroupUsecase {
  final ICampaignRepository repository;
  const CreateCampaignGroupUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String campaignId,
    required String name,
    String? description,
  }) => repository.createCampaignGroup(
    campaignId: campaignId,
    name: name,
    description: description,
  );
}

// inscribe un miembro como participante activo y le asigna su grupo inicial.
class EnrollCampaignParticipationUsecase {
  final ICampaignRepository repository;
  const EnrollCampaignParticipationUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String campaignId,
    required String membershipId,
    required String groupId,
  }) => repository.enrollParticipation(
    campaignId: campaignId,
    membershipId: membershipId,
    groupId: groupId,
  );
}

// designa a un participante como el Asociado líder de un grupo.
class AssignGroupAssociateUsecase {
  final ICampaignRepository repository;
  const AssignGroupAssociateUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String groupId,
    required String participationId,
    required String reason,
  }) => repository.assignGroupAssociate(
    groupId: groupId,
    participationId: participationId,
    reason: reason,
  );
}

// crea y delimita un territorio o campo operativo asignado a un grupo.
class CreateOperationalFieldUsecase {
  final ICampaignRepository repository;
  const CreateOperationalFieldUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String campaignId,
    required String groupId,
    required String name,
    String? organization,
    String? description,
    String? territoryNotes,
  }) => repository.createOperationalField(
    campaignId: campaignId,
    groupId: groupId,
    name: name,
    organization: organization,
    description: description,
    territoryNotes: territoryNotes,
  );
}

// solicita un cambio formal hacia otro grupo de trabajo.
class RequestGroupChangeUsecase {
  final ICampaignRepository repository;
  const RequestGroupChangeUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String participationId,
    required String requestedGroupId,
    required String reason,
  }) => repository.requestGroupChange(
    participationId: participationId,
    requestedGroupId: requestedGroupId,
    reason: reason,
  );
}

// aprueba o rechaza una solicitud de traslado de grupo.
class ResolveGroupChangeUsecase {
  final ICampaignRepository repository;
  const ResolveGroupChangeUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String requestId,
    required String outcome,
    required String resolution,
  }) => repository.resolveGroupChange(
    requestId: requestId,
    outcome: outcome,
    resolution: resolution,
  );
}

// apela una decisión rechazada de cambio de grupo.
class CreateGroupChangeAppealUsecase {
  final ICampaignRepository repository;
  const CreateGroupChangeAppealUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String requestId,
    required String reason,
  }) =>
      repository.createGroupChangeAppeal(requestId: requestId, reason: reason);
}

// resuelve definitivamente una apelación de cambio de grupo.
class ResolveGroupChangeAppealUsecase {
  final ICampaignRepository repository;
  const ResolveGroupChangeAppealUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String appealId,
    required String outcome,
    required String resolution,
  }) => repository.resolveGroupChangeAppeal(
    appealId: appealId,
    outcome: outcome,
    resolution: resolution,
  );
}

// consulta el resumen operativo completo de un grupo de campaña.
class GetGroupOverviewUsecase {
  final ICampaignRepository repository;
  const GetGroupOverviewUsecase({required this.repository});

  Future<Result<GroupOverview>> call({required String groupId}) =>
      repository.getGroupOverview(groupId: groupId);
}
