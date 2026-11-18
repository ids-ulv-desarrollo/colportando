import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/workspace/data/models/workspace_dto.dart';

abstract class IWorkspaceRemoteDataSource {
  Future<Result<WorkspaceDto>> getContext({required String token});

  Future<Result<Map<String, dynamic>>> listClubMemberships({
    required String token,
    required String clubId,
  });

  Future<Result<Map<String, dynamic>>> listClubCampaigns({
    required String token,
    required String clubId,
  });

  Future<Result<Map<String, dynamic>>> listCampaignGroups({
    required String token,
    required String campaignId,
  });

  Future<Result<Map<String, dynamic>>> listClubTrainingPrograms({
    required String token,
    required String clubId,
  });

  Future<Result<List<dynamic>>> listClubRoles({
    required String token,
    required String clubId,
  });

  Future<Result<Map<String, dynamic>>> assignClubRole({
    required String token,
    required String clubId,
    required String accountId,
    required String roleCode,
    String? reason,
  });

  Future<Result<Map<String, dynamic>>> revokeAccessAssignment({
    required String token,
    required String accessAssignmentId,
    required String reason,
  });
}

class WorkspaceRemoteDataSource implements IWorkspaceRemoteDataSource {
  final ApiClient _apiClient;

  const WorkspaceRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<WorkspaceDto>> getContext({required String token}) =>
      _apiClient.get<WorkspaceDto>(
        '/workspace/context',
        token: token,
        fromJson: (json) => WorkspaceDto.fromJson(json),
      );

  @override
  Future<Result<Map<String, dynamic>>> listClubMemberships({
    required String token,
    required String clubId,
  }) => _apiClient.get<Map<String, dynamic>>(
    '/workspace/clubs/$clubId/memberships',
    token: token,
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> listClubCampaigns({
    required String token,
    required String clubId,
  }) => _apiClient.get<Map<String, dynamic>>(
    '/workspace/clubs/$clubId/campaigns',
    token: token,
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> listCampaignGroups({
    required String token,
    required String campaignId,
  }) => _apiClient.get<Map<String, dynamic>>(
    '/workspace/campaigns/$campaignId/groups',
    token: token,
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> listClubTrainingPrograms({
    required String token,
    required String clubId,
  }) => _apiClient.get<Map<String, dynamic>>(
    '/workspace/clubs/$clubId/training-programs',
    token: token,
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<List<dynamic>>> listClubRoles({
    required String token,
    required String clubId,
  }) => _apiClient.get<List<dynamic>>(
    '/workspace/clubs/$clubId/roles',
    token: token,
    fromJson: (json) => json as List<dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> assignClubRole({
    required String token,
    required String clubId,
    required String accountId,
    required String roleCode,
    String? reason,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/workspace/clubs/$clubId/access-assignments',
    token: token,
    body: {'accountId': accountId, 'roleCode': roleCode, 'reason': ?reason},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> revokeAccessAssignment({
    required String token,
    required String accessAssignmentId,
    required String reason,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/workspace/access-assignments/$accessAssignmentId/revoke',
    token: token,
    body: {'reason': reason},
    fromJson: (json) => json as Map<String, dynamic>,
  );
}
