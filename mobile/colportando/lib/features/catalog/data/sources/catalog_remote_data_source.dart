import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/catalog/data/models/catalog_dto.dart';

// Contrato de la fuente de datos remota para el módulo de catálogo e inventario.
abstract class ICatalogRemoteDataSource {
  Future<Result<Map<String, dynamic>>> createMaterial({
    required String accessToken,
    required String clubId,
    required String code,
    required String name,
    String? description,
    String? category,
  });

  Future<Result<Map<String, dynamic>>> createCampaignCatalog({
    required String accessToken,
    required String campaignId,
    required String name,
    required String sourceType,
    required String sourceName,
    required String sourceCutAt,
    required String currency,
    String? sourceReference,
  });

  Future<Result<List<CampaignCatalogDto>>> listCampaignCatalogs({
    required String accessToken,
    required String campaignId,
  });

  Future<Result<Map<String, dynamic>>> addCatalogItem({
    required String accessToken,
    required String catalogId,
    required String materialId,
    required String listPrice,
    bool? bonusEligible,
    String? validFrom,
    String? validTo,
  });

  Future<Result<Map<String, dynamic>>> updateCatalogStatus({
    required String accessToken,
    required String catalogId,
    required String status,
  });

  Future<Result<Map<String, dynamic>>> createAcquisition({
    required String accessToken,
    required String campaignId,
    required String participationId,
    required String catalogId,
    required String acquiredAt,
    required List<Map<String, dynamic>> items,
    String? externalReference,
  });

  Future<Result<Map<String, dynamic>>> listCampaignAcquisitions({
    required String accessToken,
    required String campaignId,
    int page = 1,
    int pageSize = 25,
  });

  Future<Result<Map<String, dynamic>>> updateAcquisitionStatus({
    required String accessToken,
    required String acquisitionId,
    required String status,
    required String resolution,
  });

  Future<Result<List<CatalogMaterialDto>>> listClubMaterials({
    required String accessToken,
    required String clubId,
    int page = 1,
    int pageSize = 25,
    String? search,
  });

  Future<Result<List<CatalogAcquisitionDto>>> listMyAcquisitions({
    required String accessToken,
    int page = 1,
    int pageSize = 25,
  });
}

// Implementación de la fuente de datos remota mediante ApiClient.
class CatalogRemoteDataSource implements ICatalogRemoteDataSource {
  final ApiClient _apiClient;

  const CatalogRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<Map<String, dynamic>>> createMaterial({
    required String accessToken,
    required String clubId,
    required String code,
    required String name,
    String? description,
    String? category,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/inventory/materials',
    token: accessToken,
    body: {
      'clubId': clubId,
      'code': code,
      'name': name,
      'description': ?description,
      'category': ?category,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> createCampaignCatalog({
    required String accessToken,
    required String campaignId,
    required String name,
    required String sourceType,
    required String sourceName,
    required String sourceCutAt,
    required String currency,
    String? sourceReference,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/inventory/campaigns/$campaignId/catalogs',
    token: accessToken,
    body: {
      'name': name,
      'sourceType': sourceType,
      'sourceName': sourceName,
      'sourceCutAt': sourceCutAt,
      'currency': currency,
      'sourceReference': ?sourceReference,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<List<CampaignCatalogDto>>> listCampaignCatalogs({
    required String accessToken,
    required String campaignId,
  }) => _apiClient.get<List<CampaignCatalogDto>>(
    '/inventory/campaigns/$campaignId/catalogs',
    token: accessToken,
    fromJson: (json) =>
        ((json as Map<String, dynamic>)['catalogs'] as List<dynamic>? ?? [])
            .map(
              (item) =>
                  CampaignCatalogDto.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
  );

  @override
  Future<Result<Map<String, dynamic>>> addCatalogItem({
    required String accessToken,
    required String catalogId,
    required String materialId,
    required String listPrice,
    bool? bonusEligible,
    String? validFrom,
    String? validTo,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/inventory/catalogs/$catalogId/items',
    token: accessToken,
    body: {
      'materialId': materialId,
      'listPrice': listPrice,
      'bonusEligible': ?bonusEligible,
      'validFrom': ?validFrom,
      'validTo': ?validTo,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> updateCatalogStatus({
    required String accessToken,
    required String catalogId,
    required String status,
  }) => _apiClient.put<Map<String, dynamic>>(
    '/inventory/catalogs/$catalogId/status',
    token: accessToken,
    body: {'status': status},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> createAcquisition({
    required String accessToken,
    required String campaignId,
    required String participationId,
    required String catalogId,
    required String acquiredAt,
    required List<Map<String, dynamic>> items,
    String? externalReference,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/inventory/campaigns/$campaignId/acquisitions',
    token: accessToken,
    body: {
      'participationId': participationId,
      'catalogId': catalogId,
      'acquiredAt': acquiredAt,
      'items': items,
      'externalReference': ?externalReference,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> listCampaignAcquisitions({
    required String accessToken,
    required String campaignId,
    int page = 1,
    int pageSize = 25,
  }) => _apiClient.get<Map<String, dynamic>>(
    '/inventory/campaigns/$campaignId/acquisitions?page=$page&pageSize=$pageSize',
    token: accessToken,
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> updateAcquisitionStatus({
    required String accessToken,
    required String acquisitionId,
    required String status,
    required String resolution,
  }) => _apiClient.put<Map<String, dynamic>>(
    '/inventory/acquisitions/$acquisitionId/status',
    token: accessToken,
    body: {'status': status, 'resolution': resolution},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<List<CatalogMaterialDto>>> listClubMaterials({
    required String accessToken,
    required String clubId,
    int page = 1,
    int pageSize = 25,
    String? search,
  }) {
    final query = search != null && search.trim().isNotEmpty
        ? '&search=${Uri.encodeComponent(search.trim())}'
        : '';
    return _apiClient.get<List<CatalogMaterialDto>>(
      '/inventory/clubs/$clubId/materials?page=$page&pageSize=$pageSize$query',
      token: accessToken,
      fromJson: (json) =>
          ((json as Map<String, dynamic>)['items'] as List<dynamic>? ?? [])
              .map(
                (item) =>
                    CatalogMaterialDto.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  @override
  Future<Result<List<CatalogAcquisitionDto>>> listMyAcquisitions({
    required String accessToken,
    int page = 1,
    int pageSize = 25,
  }) => _apiClient.get<List<CatalogAcquisitionDto>>(
    '/inventory/me/acquisitions?page=$page&pageSize=$pageSize',
    token: accessToken,
    fromJson: (json) =>
        ((json as Map<String, dynamic>)['items'] as List<dynamic>? ?? [])
            .map(
              (item) =>
                  CatalogAcquisitionDto.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
  );
}
