import 'package:colportando/features/campaigns/domain/entities/group_overview.dart';
import 'package:colportando/features/campaigns/presentation/riverpod/campaign_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign_riverpod.freezed.dart';

// Estado inmutable del módulo de operaciones de campaña.
@freezed
abstract class CampaignState with _$CampaignState {
  const factory CampaignState({
    @Default(false) bool isLoading,
    String? errorMessage,
    GroupOverview? groupOverview,
  }) = _CampaignState;
}

// Notificador que gestiona el estado y las acciones operativas de campaña.
class CampaignNotifier extends Notifier<CampaignState> {
  @override
  CampaignState build() => const CampaignState();

  // Planifica y registra una nueva campaña para el club.
  Future<Map<String, dynamic>?> createCampaign({
    required String clubId,
    required String name,
    required String startsOn,
    required String endsOn,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createCampaignUsecaseProvider)(
      clubId: clubId,
      name: name,
      startsOn: startsOn,
      endsOn: endsOn,
      description: description,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Activa, cierra o cancela una campaña.
  Future<Map<String, dynamic>?> changeCampaignStatus({
    required String campaignId,
    required String status,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(changeCampaignStatusUsecaseProvider)(
      campaignId: campaignId,
      status: status,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Crea un grupo de trabajo dentro de una campaña.
  Future<Map<String, dynamic>?> createCampaignGroup({
    required String campaignId,
    required String name,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createCampaignGroupUsecaseProvider)(
      campaignId: campaignId,
      name: name,
      description: description,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Inscribe un miembro como participante activo y le asigna su grupo inicial.
  Future<Map<String, dynamic>?> enrollParticipation({
    required String campaignId,
    required String membershipId,
    required String groupId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(enrollCampaignParticipationUsecaseProvider)(
      campaignId: campaignId,
      membershipId: membershipId,
      groupId: groupId,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Designa a un participante como el Asociado líder de un grupo.
  Future<Map<String, dynamic>?> assignGroupAssociate({
    required String groupId,
    required String participationId,
    required String reason,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(assignGroupAssociateUsecaseProvider)(
      groupId: groupId,
      participationId: participationId,
      reason: reason,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Crea y delimita un territorio o campo operativo asignado a un grupo.
  Future<Map<String, dynamic>?> createOperationalField({
    required String campaignId,
    required String groupId,
    required String name,
    String? organization,
    String? description,
    String? territoryNotes,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createOperationalFieldUsecaseProvider)(
      campaignId: campaignId,
      groupId: groupId,
      name: name,
      organization: organization,
      description: description,
      territoryNotes: territoryNotes,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Solicita cambio formal hacia otro grupo de trabajo.
  Future<Map<String, dynamic>?> requestGroupChange({
    required String participationId,
    required String requestedGroupId,
    required String reason,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(requestGroupChangeUsecaseProvider)(
      participationId: participationId,
      requestedGroupId: requestedGroupId,
      reason: reason,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Resuelve una solicitud de cambio de grupo (aprobar o rechazar).
  Future<Map<String, dynamic>?> resolveGroupChange({
    required String requestId,
    required String outcome,
    required String resolution,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(resolveGroupChangeUsecaseProvider)(
      requestId: requestId,
      outcome: outcome,
      resolution: resolution,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Apela la decisión de una solicitud de traslado rechazada.
  Future<Map<String, dynamic>?> createGroupChangeAppeal({
    required String requestId,
    required String reason,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createGroupChangeAppealUsecaseProvider)(
      requestId: requestId,
      reason: reason,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Resuelve definitivamente una apelación presentada.
  Future<Map<String, dynamic>?> resolveGroupChangeAppeal({
    required String appealId,
    required String outcome,
    required String resolution,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(resolveGroupChangeAppealUsecaseProvider)(
      appealId: appealId,
      outcome: outcome,
      resolution: resolution,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Consulta el resumen operativo completo del grupo.
  Future<GroupOverview?> getGroupOverview({
    required String groupId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(getGroupOverviewUsecaseProvider)(
      groupId: groupId,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
      groupOverview: result.data,
    );
    return result.data;
  }
}

// Proveedor global para el módulo de operaciones de campaña.
final campaignProvider =
    NotifierProvider<CampaignNotifier, CampaignState>(() {
  return CampaignNotifier();
});
