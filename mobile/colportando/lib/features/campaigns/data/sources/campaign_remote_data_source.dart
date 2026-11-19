import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/campaigns/data/models/group_overview_dto.dart';

// Contrato de la fuente de datos remota para el módulo de operaciones de campaña.
abstract class ICampaignRemoteDataSource {
  Future<Result<Map<String, dynamic>>> createCampaign({
    required String accessToken,
    required String clubId,
    required String name,
    required String startsOn,
    required String endsOn,
    String? description,
  });

  Future<Result<Map<String, dynamic>>> changeCampaignStatus({
    required String accessToken,
    required String campaignId,
    required String status,
  });

  Future<Result<Map<String, dynamic>>> createCampaignGroup({
    required String accessToken,
    required String campaignId,
    required String name,
    String? description,
  });

  Future<Result<Map<String, dynamic>>> enrollParticipation({
    required String accessToken,
    required String campaignId,
    required String membershipId,
    required String groupId,
  });

  Future<Result<Map<String, dynamic>>> assignGroupAssociate({
    required String accessToken,
    required String groupId,
    required String participationId,
    required String reason,
  });

  Future<Result<Map<String, dynamic>>> createOperationalField({
    required String accessToken,
    required String campaignId,
    required String groupId,
    required String name,
    String? organization,
    String? description,
    String? territoryNotes,
  });

  Future<Result<Map<String, dynamic>>> requestGroupChange({
    required String accessToken,
    required String participationId,
    required String requestedGroupId,
    required String reason,
  });

  Future<Result<Map<String, dynamic>>> resolveGroupChange({
    required String accessToken,
    required String requestId,
    required String outcome,
    required String resolution,
  });

  Future<Result<Map<String, dynamic>>> createGroupChangeAppeal({
    required String accessToken,
    required String requestId,
    required String reason,
  });

  Future<Result<Map<String, dynamic>>> resolveGroupChangeAppeal({
    required String accessToken,
    required String appealId,
    required String outcome,
    required String resolution,
  });

  Future<Result<GroupOverviewDto>> getGroupOverview({
    required String accessToken,
    required String groupId,
  });
}

// Implementación concreta que se comunica con el backend mediante ApiClient.
class CampaignRemoteDataSourceImpl implements ICampaignRemoteDataSource {
  final ApiClient client;
  CampaignRemoteDataSourceImpl({required this.client});

  @override
  Future<Result<Map<String, dynamic>>> createCampaign({
    required String accessToken,
    required String clubId,
    required String name,
    required String startsOn,
    required String endsOn,
    String? description,
  }) => client.post<Map<String, dynamic>>(
    '/operations/campaigns',
    token: accessToken,
    body: {
      'clubId': clubId,
      'name': name,
      'startsOn': startsOn,
      'endsOn': endsOn,
      if (description != null) 'description': description,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> changeCampaignStatus({
    required String accessToken,
    required String campaignId,
    required String status,
  }) => client.put<Map<String, dynamic>>(
    '/operations/campaigns/$campaignId/status',
    token: accessToken,
    body: {'status': status},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> createCampaignGroup({
    required String accessToken,
    required String campaignId,
    required String name,
    String? description,
  }) => client.post<Map<String, dynamic>>(
    '/operations/campaigns/$campaignId/groups',
    token: accessToken,
    body: {
      'name': name,
      if (description != null) 'description': description,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> enrollParticipation({
    required String accessToken,
    required String campaignId,
    required String membershipId,
    required String groupId,
  }) => client.post<Map<String, dynamic>>(
    '/operations/campaigns/$campaignId/participations',
    token: accessToken,
    body: {
      'membershipId': membershipId,
      'groupId': groupId,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> assignGroupAssociate({
    required String accessToken,
    required String groupId,
    required String participationId,
    required String reason,
  }) => client.put<Map<String, dynamic>>(
    '/operations/groups/$groupId/associate',
    token: accessToken,
    body: {
      'participationId': participationId,
      'reason': reason,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> createOperationalField({
    required String accessToken,
    required String campaignId,
    required String groupId,
    required String name,
    String? organization,
    String? description,
    String? territoryNotes,
  }) => client.post<Map<String, dynamic>>(
    '/operations/campaigns/$campaignId/fields',
    token: accessToken,
    body: {
      'groupId': groupId,
      'name': name,
      if (organization != null) 'organization': organization,
      if (description != null) 'description': description,
      if (territoryNotes != null) 'territoryNotes': territoryNotes,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> requestGroupChange({
    required String accessToken,
    required String participationId,
    required String requestedGroupId,
    required String reason,
  }) => client.post<Map<String, dynamic>>(
    '/operations/participations/$participationId/group-change-requests',
    token: accessToken,
    body: {
      'requestedGroupId': requestedGroupId,
      'reason': reason,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> resolveGroupChange({
    required String accessToken,
    required String requestId,
    required String outcome,
    required String resolution,
  }) => client.post<Map<String, dynamic>>(
    '/operations/group-change-requests/$requestId/resolve',
    token: accessToken,
    body: {
      'outcome': outcome,
      'resolution': resolution,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> createGroupChangeAppeal({
    required String accessToken,
    required String requestId,
    required String reason,
  }) => client.post<Map<String, dynamic>>(
    '/operations/group-change-requests/$requestId/appeals',
    token: accessToken,
    body: {'reason': reason},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> resolveGroupChangeAppeal({
    required String accessToken,
    required String appealId,
    required String outcome,
    required String resolution,
  }) => client.post<Map<String, dynamic>>(
    '/operations/group-change-appeals/$appealId/resolve',
    token: accessToken,
    body: {
      'outcome': outcome,
      'resolution': resolution,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<GroupOverviewDto>> getGroupOverview({
    required String accessToken,
    required String groupId,
  }) => client.get<GroupOverviewDto>(
    '/operations/groups/$groupId/overview',
    token: accessToken,
    fromJson: (json) => GroupOverviewDto.fromJson(json as Map<String, dynamic>),
  );
}
