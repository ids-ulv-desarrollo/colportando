import 'package:colportando/features/workspace/domain/entities/workspace.dart';
import 'package:colportando/features/workspace/presentation/riverpod/workspace_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_riverpod.freezed.dart';

// Estado inmutable de workspace.
@freezed
abstract class WorkspaceState with _$WorkspaceState {
  const factory WorkspaceState({
    @Default(false) bool isLoading,
    String? errorMessage,
    Workspace? workspace,
  }) = _WorkspaceState;
}

// Notificador que gestiona el estado y las acciones de workspace.
class WorkspaceNotifier extends Notifier<WorkspaceState> {
  @override
  WorkspaceState build() => const WorkspaceState();

  // Consulta el contexto de clubes, membresías y roles del usuario autenticado.
  Future<void> getContext() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(getWorkspaceContextUsecaseProvider)();

    if (result.isSuccess) {
      state = state.copyWith(isLoading: false, workspace: result.data);
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.error);
    }
  }

  // Lista las membresías registradas en un club.
  Future<Map<String, dynamic>?> listClubMemberships({
    required String clubId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(listClubMembershipsUsecaseProvider)(
      clubId: clubId,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Lista las campañas visibles en el club seleccionado.
  Future<Map<String, dynamic>?> listClubCampaigns({
    required String clubId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(listClubCampaignsUsecaseProvider)(
      clubId: clubId,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Lista los grupos visibles dentro de una campaña específica.
  Future<Map<String, dynamic>?> listCampaignGroups({
    required String campaignId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(listCampaignGroupsUsecaseProvider)(
      campaignId: campaignId,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Lista los programas de capacitación visibles en el club.
  Future<Map<String, dynamic>?> listClubTrainingPrograms({
    required String clubId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(listClubTrainingProgramsUsecaseProvider)(
      clubId: clubId,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Lista los roles fijos asignables dentro de un club.
  Future<List<dynamic>?> listClubRoles({required String clubId}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(listClubRolesUsecaseProvider)(clubId: clubId);
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Asigna un rol fijo del sistema en el ámbito del club.
  Future<Map<String, dynamic>?> assignClubRole({
    required String clubId,
    required String accountId,
    required String roleCode,
    String? reason,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(assignClubRoleUsecaseProvider)(
      clubId: clubId,
      accountId: accountId,
      roleCode: roleCode,
      reason: reason,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Revoca una asignación de rol sin eliminar el historial.
  Future<Map<String, dynamic>?> revokeAccessAssignment({
    required String accessAssignmentId,
    required String reason,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(revokeAccessAssignmentUsecaseProvider)(
      accessAssignmentId: accessAssignmentId,
      reason: reason,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }
}

// Proveedor global que consume la interfaz de usuario.
final workspaceProvider = NotifierProvider<WorkspaceNotifier, WorkspaceState>(
  () {
    return WorkspaceNotifier();
  },
);
