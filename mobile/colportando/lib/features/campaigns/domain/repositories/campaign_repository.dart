import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/campaigns/domain/entities/group_overview.dart';

// Contrato de repositorio para el módulo de operaciones de campaña.
abstract class ICampaignRepository {
  Future<Result<Map<String, dynamic>>> createCampaign({
    required String clubId,
    required String name,
    required String startsOn,
    required String endsOn,
    String? description,
  });

  Future<Result<Map<String, dynamic>>> changeCampaignStatus({
    required String campaignId,
    required String status,
  });

  Future<Result<Map<String, dynamic>>> createCampaignGroup({
    required String campaignId,
    required String name,
    String? description,
  });

  Future<Result<Map<String, dynamic>>> enrollParticipation({
    required String campaignId,
    required String membershipId,
    required String groupId,
  });

  Future<Result<Map<String, dynamic>>> assignGroupAssociate({
    required String groupId,
    required String participationId,
    required String reason,
  });

  Future<Result<Map<String, dynamic>>> createOperationalField({
    required String campaignId,
    required String groupId,
    required String name,
    String? organization,
    String? description,
    String? territoryNotes,
  });

  Future<Result<Map<String, dynamic>>> requestGroupChange({
    required String participationId,
    required String requestedGroupId,
    required String reason,
  });

  Future<Result<Map<String, dynamic>>> resolveGroupChange({
    required String requestId,
    required String outcome,
    required String resolution,
  });

  Future<Result<Map<String, dynamic>>> createGroupChangeAppeal({
    required String requestId,
    required String reason,
  });

  Future<Result<Map<String, dynamic>>> resolveGroupChangeAppeal({
    required String appealId,
    required String outcome,
    required String resolution,
  });

  Future<Result<GroupOverview>> getGroupOverview({
    required String groupId,
  });
}
