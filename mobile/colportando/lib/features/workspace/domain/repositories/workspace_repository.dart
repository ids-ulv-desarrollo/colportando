import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/workspace/domain/entities/workspace.dart';

abstract class IWorkspaceRepository {
  Future<Result<Workspace>> getContext();

  Future<Result<Map<String, dynamic>>> listClubMemberships({
    required String clubId,
  });

  Future<Result<Map<String, dynamic>>> listClubCampaigns({
    required String clubId,
  });

  Future<Result<Map<String, dynamic>>> listCampaignGroups({
    required String campaignId,
  });

  Future<Result<Map<String, dynamic>>> listClubTrainingPrograms({
    required String clubId,
  });

  Future<Result<List<dynamic>>> listClubRoles({required String clubId});

  Future<Result<Map<String, dynamic>>> assignClubRole({
    required String clubId,
    required String accountId,
    required String roleCode,
    String? reason,
  });

  Future<Result<Map<String, dynamic>>> revokeAccessAssignment({
    required String accessAssignmentId,
    required String reason,
  });
}
