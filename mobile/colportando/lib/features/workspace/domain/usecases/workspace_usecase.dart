import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/workspace/domain/entities/workspace.dart';
import 'package:colportando/features/workspace/domain/repositories/workspace_repository.dart';

class GetWorkspaceContextUsecase {
  final IWorkspaceRepository repository;

  const GetWorkspaceContextUsecase({required this.repository});

  Future<Result<Workspace>> call() => repository.getContext();
}

class ListClubMembershipsUsecase {
  final IWorkspaceRepository repository;

  const ListClubMembershipsUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({required String clubId}) =>
      repository.listClubMemberships(clubId: clubId);
}

class ListClubCampaignsUsecase {
  final IWorkspaceRepository repository;

  const ListClubCampaignsUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({required String clubId}) =>
      repository.listClubCampaigns(clubId: clubId);
}

class ListCampaignGroupsUsecase {
  final IWorkspaceRepository repository;

  const ListCampaignGroupsUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({required String campaignId}) =>
      repository.listCampaignGroups(campaignId: campaignId);
}

class ListClubTrainingProgramsUsecase {
  final IWorkspaceRepository repository;

  const ListClubTrainingProgramsUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({required String clubId}) =>
      repository.listClubTrainingPrograms(clubId: clubId);
}

class ListClubRolesUsecase {
  final IWorkspaceRepository repository;

  const ListClubRolesUsecase({required this.repository});

  Future<Result<List<dynamic>>> call({required String clubId}) =>
      repository.listClubRoles(clubId: clubId);
}

class AssignClubRoleUsecase {
  final IWorkspaceRepository repository;

  const AssignClubRoleUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String clubId,
    required String accountId,
    required String roleCode,
    String? reason,
  }) => repository.assignClubRole(
    clubId: clubId,
    accountId: accountId,
    roleCode: roleCode,
    reason: reason,
  );
}

class RevokeAccessAssignmentUsecase {
  final IWorkspaceRepository repository;

  const RevokeAccessAssignmentUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String accessAssignmentId,
    required String reason,
  }) => repository.revokeAccessAssignment(
    accessAssignmentId: accessAssignmentId,
    reason: reason,
  );
}
