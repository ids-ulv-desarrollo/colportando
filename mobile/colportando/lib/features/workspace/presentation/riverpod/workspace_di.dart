import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:colportando/features/workspace/data/sources/workspace_remote_data_source.dart';
import 'package:colportando/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:colportando/features/workspace/domain/usecases/workspace_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Fuente de datos remota de workspace.
final _workspaceRemoteDataSourceProvider = Provider<IWorkspaceRemoteDataSource>(
  (ref) {
    final apiClient = ref.watch(apiClientProvider);
    return WorkspaceRemoteDataSource(apiClient: apiClient);
  },
);

// Repositorio de workspace.
final _workspaceRepositoryProvider = Provider<IWorkspaceRepository>((ref) {
  final remoteDataSource = ref.watch(_workspaceRemoteDataSourceProvider);
  return WorkspaceRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Casos de uso de workspace expuestos para el estado y la UI.
final getWorkspaceContextUsecaseProvider = Provider<GetWorkspaceContextUsecase>(
  (ref) {
    return GetWorkspaceContextUsecase(
      repository: ref.watch(_workspaceRepositoryProvider),
    );
  },
);

final listClubMembershipsUsecaseProvider = Provider<ListClubMembershipsUsecase>(
  (ref) {
    return ListClubMembershipsUsecase(
      repository: ref.watch(_workspaceRepositoryProvider),
    );
  },
);

final listClubCampaignsUsecaseProvider = Provider<ListClubCampaignsUsecase>((
  ref,
) {
  return ListClubCampaignsUsecase(
    repository: ref.watch(_workspaceRepositoryProvider),
  );
});

final listCampaignGroupsUsecaseProvider = Provider<ListCampaignGroupsUsecase>((
  ref,
) {
  return ListCampaignGroupsUsecase(
    repository: ref.watch(_workspaceRepositoryProvider),
  );
});

final listClubTrainingProgramsUsecaseProvider =
    Provider<ListClubTrainingProgramsUsecase>((ref) {
      return ListClubTrainingProgramsUsecase(
        repository: ref.watch(_workspaceRepositoryProvider),
      );
    });

final listClubRolesUsecaseProvider = Provider<ListClubRolesUsecase>((ref) {
  return ListClubRolesUsecase(
    repository: ref.watch(_workspaceRepositoryProvider),
  );
});

final assignClubRoleUsecaseProvider = Provider<AssignClubRoleUsecase>((ref) {
  return AssignClubRoleUsecase(
    repository: ref.watch(_workspaceRepositoryProvider),
  );
});

final revokeAccessAssignmentUsecaseProvider =
    Provider<RevokeAccessAssignmentUsecase>((ref) {
      return RevokeAccessAssignmentUsecase(
        repository: ref.watch(_workspaceRepositoryProvider),
      );
    });
