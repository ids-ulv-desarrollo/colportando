import 'package:colportando/features/catalog/domain/entities/catalog.dart';
import 'package:colportando/features/catalog/presentation/riverpod/catalog_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_riverpod.freezed.dart';

// Estado inmutable del catálogo y materiales.
@freezed
abstract class CatalogState with _$CatalogState {
  const factory CatalogState({
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default([]) List<CatalogMaterial> materials,
    @Default([]) List<CampaignCatalog> catalogs,
    @Default([]) List<CatalogAcquisition> myAcquisitions,
    Map<String, dynamic>? lastOperationResult,
  }) = _CatalogState;
}

// Notificador que gestiona el estado y las acciones del catálogo de materiales.
class CatalogNotifier extends Notifier<CatalogState> {
  @override
  CatalogState build() => const CatalogState();

  // Da de alta un nuevo material maestro en el tenant del club.
  Future<Map<String, dynamic>?> createMaterial({
    required String clubId,
    required String code,
    required String name,
    String? description,
    String? category,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createMaterialUsecaseProvider)(
      clubId: clubId,
      code: code,
      name: name,
      description: description,
      category: category,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
      lastOperationResult: result.data,
    );
    return result.data;
  }

  // Crea un borrador de catálogo inmutable para la campaña.
  Future<Map<String, dynamic>?> createCampaignCatalog({
    required String campaignId,
    required String name,
    required String sourceType,
    required String sourceName,
    required String sourceCutAt,
    required String currency,
    String? sourceReference,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createCampaignCatalogUsecaseProvider)(
      campaignId: campaignId,
      name: name,
      sourceType: sourceType,
      sourceName: sourceName,
      sourceCutAt: sourceCutAt,
      currency: currency,
      sourceReference: sourceReference,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
      lastOperationResult: result.data,
    );
    return result.data;
  }

  // Lista los snapshots de catálogos y artículos de una campaña.
  Future<List<CampaignCatalog>?> listCampaignCatalogs({
    required String campaignId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(listCampaignCatalogsUsecaseProvider)(
      campaignId: campaignId,
    );
    if (result.isSuccess) {
      state = state.copyWith(isLoading: false, catalogs: result.data ?? []);
      return result.data;
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.error);
      return null;
    }
  }

  // Agrega un material con precio al borrador de catálogo.
  Future<Map<String, dynamic>?> addCatalogItem({
    required String catalogId,
    required String materialId,
    required String listPrice,
    bool? bonusEligible,
    String? validFrom,
    String? validTo,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(addCatalogItemUsecaseProvider)(
      catalogId: catalogId,
      materialId: materialId,
      listPrice: listPrice,
      bonusEligible: bonusEligible,
      validFrom: validFrom,
      validTo: validTo,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
      lastOperationResult: result.data,
    );
    return result.data;
  }

  // Publica o cierra un catálogo de campaña.
  Future<Map<String, dynamic>?> updateCatalogStatus({
    required String catalogId,
    required String status,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(updateCatalogStatusUsecaseProvider)(
      catalogId: catalogId,
      status: status,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
      lastOperationResult: result.data,
    );
    return result.data;
  }

  // Registra la asignación de materiales a un participante con precios vigentes.
  Future<Map<String, dynamic>?> createAcquisition({
    required String campaignId,
    required String participationId,
    required String catalogId,
    required String acquiredAt,
    required List<Map<String, dynamic>> items,
    String? externalReference,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createAcquisitionUsecaseProvider)(
      campaignId: campaignId,
      participationId: participationId,
      catalogId: catalogId,
      acquiredAt: acquiredAt,
      items: items,
      externalReference: externalReference,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
      lastOperationResult: result.data,
    );
    return result.data;
  }

  // Lista las asignaciones de material en una campaña.
  Future<Map<String, dynamic>?> listCampaignAcquisitions({
    required String campaignId,
    int page = 1,
    int pageSize = 25,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(listCampaignAcquisitionsUsecaseProvider)(
      campaignId: campaignId,
      page: page,
      pageSize: pageSize,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
      lastOperationResult: result.data,
    );
    return result.data;
  }

  // Modifica el estado de una adquisición a entregado o cancelado.
  Future<Map<String, dynamic>?> updateAcquisitionStatus({
    required String acquisitionId,
    required String status,
    required String resolution,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(updateAcquisitionStatusUsecaseProvider)(
      acquisitionId: acquisitionId,
      status: status,
      resolution: resolution,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
      lastOperationResult: result.data,
    );
    return result.data;
  }

  // Lista los materiales del club para poblar selectores.
  Future<List<CatalogMaterial>?> listClubMaterials({
    required String clubId,
    int page = 1,
    int pageSize = 25,
    String? search,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(listClubMaterialsUsecaseProvider)(
      clubId: clubId,
      page: page,
      pageSize: pageSize,
      search: search,
    );
    if (result.isSuccess) {
      state = state.copyWith(isLoading: false, materials: result.data ?? []);
      return result.data;
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.error);
      return null;
    }
  }

  // Lista el historial de materiales asignados a la cuenta actualmente autenticada.
  Future<List<CatalogAcquisition>?> listMyAcquisitions({
    int page = 1,
    int pageSize = 25,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(listMyAcquisitionsUsecaseProvider)(
      page: page,
      pageSize: pageSize,
    );
    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        myAcquisitions: result.data ?? [],
      );
      return result.data;
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.error);
      return null;
    }
  }
}

// Proveedor global que consume la interfaz de usuario.
final catalogProvider = NotifierProvider<CatalogNotifier, CatalogState>(() {
  return CatalogNotifier();
});
