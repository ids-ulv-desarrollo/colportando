import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/catalog/domain/entities/catalog.dart';

// Contrato abstracto del repositorio de catálogos y materiales.
abstract class ICatalogRepository {
  Future<Result<Map<String, dynamic>>> createMaterial({
    required String clubId,
    required String code,
    required String name,
    String? description,
    String? category,
  });

  Future<Result<Map<String, dynamic>>> createCampaignCatalog({
    required String campaignId,
    required String name,
    required String sourceType,
    required String sourceName,
    required String sourceCutAt,
    required String currency,
    String? sourceReference,
  });

  Future<Result<List<CampaignCatalog>>> listCampaignCatalogs({
    required String campaignId,
  });

  Future<Result<Map<String, dynamic>>> addCatalogItem({
    required String catalogId,
    required String materialId,
    required String listPrice,
    bool? bonusEligible,
    String? validFrom,
    String? validTo,
  });

  Future<Result<Map<String, dynamic>>> updateCatalogStatus({
    required String catalogId,
    required String status,
  });

  Future<Result<Map<String, dynamic>>> createAcquisition({
    required String campaignId,
    required String participationId,
    required String catalogId,
    required String acquiredAt,
    required List<Map<String, dynamic>> items,
    String? externalReference,
  });

  Future<Result<Map<String, dynamic>>> listCampaignAcquisitions({
    required String campaignId,
    int page = 1,
    int pageSize = 25,
  });

  Future<Result<Map<String, dynamic>>> updateAcquisitionStatus({
    required String acquisitionId,
    required String status,
    required String resolution,
  });

  Future<Result<List<CatalogMaterial>>> listClubMaterials({
    required String clubId,
    int page = 1,
    int pageSize = 25,
    String? search,
  });

  Future<Result<List<CatalogAcquisition>>> listMyAcquisitions({
    int page = 1,
    int pageSize = 25,
  });
}
