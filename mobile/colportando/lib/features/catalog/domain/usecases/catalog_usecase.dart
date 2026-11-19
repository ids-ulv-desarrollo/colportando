import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/catalog/domain/entities/catalog.dart';
import 'package:colportando/features/catalog/domain/repositories/catalog_repository.dart';

// Registra un nuevo material en el tenant del club.
class CreateMaterialUsecase {
  final ICatalogRepository repository;

  const CreateMaterialUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String clubId,
    required String code,
    required String name,
    String? description,
    String? category,
  }) => repository.createMaterial(
    clubId: clubId,
    code: code,
    name: name,
    description: description,
    category: category,
  );
}

// Crea un borrador de catálogo inmutable asociado a una campaña.
class CreateCampaignCatalogUsecase {
  final ICatalogRepository repository;

  const CreateCampaignCatalogUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String campaignId,
    required String name,
    required String sourceType,
    required String sourceName,
    required String sourceCutAt,
    required String currency,
    String? sourceReference,
  }) => repository.createCampaignCatalog(
    campaignId: campaignId,
    name: name,
    sourceType: sourceType,
    sourceName: sourceName,
    sourceCutAt: sourceCutAt,
    currency: currency,
    sourceReference: sourceReference,
  );
}

// Lista los snapshots de catálogos y sus artículos con precios para una campaña.
class ListCampaignCatalogsUsecase {
  final ICatalogRepository repository;

  const ListCampaignCatalogsUsecase({required this.repository});

  Future<Result<List<CampaignCatalog>>> call({required String campaignId}) =>
      repository.listCampaignCatalogs(campaignId: campaignId);
}

// Agrega un material con precio al borrador de catálogo.
class AddCatalogItemUsecase {
  final ICatalogRepository repository;

  const AddCatalogItemUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String catalogId,
    required String materialId,
    required String listPrice,
    bool? bonusEligible,
    String? validFrom,
    String? validTo,
  }) => repository.addCatalogItem(
    catalogId: catalogId,
    materialId: materialId,
    listPrice: listPrice,
    bonusEligible: bonusEligible,
    validFrom: validFrom,
    validTo: validTo,
  );
}

// Publica o cierra un catálogo de campaña.
class UpdateCatalogStatusUsecase {
  final ICatalogRepository repository;

  const UpdateCatalogStatusUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String catalogId,
    required String status,
  }) => repository.updateCatalogStatus(catalogId: catalogId, status: status);
}

// Registra la asignación de materiales a un participante con precios vigentes.
class CreateAcquisitionUsecase {
  final ICatalogRepository repository;

  const CreateAcquisitionUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String campaignId,
    required String participationId,
    required String catalogId,
    required String acquiredAt,
    required List<Map<String, dynamic>> items,
    String? externalReference,
  }) => repository.createAcquisition(
    campaignId: campaignId,
    participationId: participationId,
    catalogId: catalogId,
    acquiredAt: acquiredAt,
    items: items,
    externalReference: externalReference,
  );
}

// Lista las asignaciones de material realizadas en una campaña.
class ListCampaignAcquisitionsUsecase {
  final ICatalogRepository repository;

  const ListCampaignAcquisitionsUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String campaignId,
    int page = 1,
    int pageSize = 25,
  }) => repository.listCampaignAcquisitions(
    campaignId: campaignId,
    page: page,
    pageSize: pageSize,
  );
}

// Actualiza el estado de una adquisición a entregado o cancelado.
class UpdateAcquisitionStatusUsecase {
  final ICatalogRepository repository;

  const UpdateAcquisitionStatusUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String acquisitionId,
    required String status,
    required String resolution,
  }) => repository.updateAcquisitionStatus(
    acquisitionId: acquisitionId,
    status: status,
    resolution: resolution,
  );
}

// Lista los materiales del club para poblar selectores en catálogo.
class ListClubMaterialsUsecase {
  final ICatalogRepository repository;

  const ListClubMaterialsUsecase({required this.repository});

  Future<Result<List<CatalogMaterial>>> call({
    required String clubId,
    int page = 1,
    int pageSize = 25,
    String? search,
  }) => repository.listClubMaterials(
    clubId: clubId,
    page: page,
    pageSize: pageSize,
    search: search,
  );
}

// Lista los materiales asignados al participante actualmente autenticado.
class ListMyAcquisitionsUsecase {
  final ICatalogRepository repository;

  const ListMyAcquisitionsUsecase({required this.repository});

  Future<Result<List<CatalogAcquisition>>> call({
    int page = 1,
    int pageSize = 25,
  }) => repository.listMyAcquisitions(page: page, pageSize: pageSize);
}
