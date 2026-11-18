import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/storage/secure_storage.dart';
import 'package:colportando/features/workspace/data/sources/workspace_remote_data_source.dart';
import 'package:colportando/features/workspace/domain/entities/workspace.dart';
import 'package:colportando/features/workspace/domain/repositories/workspace_repository.dart';

class WorkspaceRepositoryImpl implements IWorkspaceRepository {
  final IWorkspaceRemoteDataSource remoteDataSource;

  const WorkspaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<Workspace>> getContext() async {
    final token = SecureStorage.accessToken;
    if (token == null) return const Result.failure('Sin sesión activa.');
    final result = await remoteDataSource.getContext(token: token);
    return result.map((dto) => dto.toEntity());
  }

  @override
  Future<Result<Map<String, dynamic>>> listClubMemberships({
    required String clubId,
  }) async {
    final token = SecureStorage.accessToken;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.listClubMemberships(token: token, clubId: clubId);
  }

  @override
  Future<Result<Map<String, dynamic>>> listClubCampaigns({
    required String clubId,
  }) async {
    final token = SecureStorage.accessToken;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.listClubCampaigns(token: token, clubId: clubId);
  }

  @override
  Future<Result<Map<String, dynamic>>> listCampaignGroups({
    required String campaignId,
  }) async {
    final token = SecureStorage.accessToken;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.listCampaignGroups(
      token: token,
      campaignId: campaignId,
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> listClubTrainingPrograms({
    required String clubId,
  }) async {
    final token = SecureStorage.accessToken;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.listClubTrainingPrograms(
      token: token,
      clubId: clubId,
    );
  }

  @override
  Future<Result<List<dynamic>>> listClubRoles({required String clubId}) async {
    final token = SecureStorage.accessToken;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.listClubRoles(token: token, clubId: clubId);
  }

  @override
  Future<Result<Map<String, dynamic>>> assignClubRole({
    required String clubId,
    required String accountId,
    required String roleCode,
    String? reason,
  }) async {
    final token = SecureStorage.accessToken;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.assignClubRole(
      token: token,
      clubId: clubId,
      accountId: accountId,
      roleCode: roleCode,
      reason: reason,
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> revokeAccessAssignment({
    required String accessAssignmentId,
    required String reason,
  }) async {
    final token = SecureStorage.accessToken;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.revokeAccessAssignment(
      token: token,
      accessAssignmentId: accessAssignmentId,
      reason: reason,
    );
  }
}
