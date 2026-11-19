import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/storage/secure_storage.dart';
import 'package:colportando/features/catalog/data/sources/catalog_remote_data_source.dart';
import 'package:colportando/features/catalog/domain/entities/catalog.dart';
import 'package:colportando/features/catalog/domain/repositories/catalog_repository.dart';

// Implementación del repositorio de catálogos y materiales.
class CatalogRepositoryImpl implements ICatalogRepository {
  final ICatalogRemoteDataSource remoteDataSource;

  const CatalogRepositoryImpl({required this.remoteDataSource});

  String? get _token => SecureStorage.accessToken;

  @override
  Future<Result<Map<String, dynamic>>> createMaterial({
    required String clubId,
    required String code,
    required String name,
    String? description,
    String? category,
  }) async {
    final token = _token;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.createMaterial(
      accessToken: token,
      clubId: clubId,
      code: code,
      name: name,
      description: description,
      category: category,
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> createCampaignCatalog({
    required String campaignId,
    required String name,
    required String sourceType,
    required String sourceName,
    required String sourceCutAt,
    required String currency,
    String? sourceReference,
  }) async {
    final token = _token;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.createCampaignCatalog(
      accessToken: token,
      campaignId: campaignId,
      name: name,
      sourceType: sourceType,
      sourceName: sourceName,
      sourceCutAt: sourceCutAt,
      currency: currency,
      sourceReference: sourceReference,
    );
  }

  @override
  Future<Result<List<CampaignCatalog>>> listCampaignCatalogs({
    required String campaignId,
  }) async {
    final token = _token;
    if (token == null) return const Result.failure('Sin sesión activa.');
    final result = await remoteDataSource.listCampaignCatalogs(
      accessToken: token,
      campaignId: campaignId,
    );
    return result.map((list) => list.map((dto) => dto.toEntity()).toList());
  }

  @override
  Future<Result<Map<String, dynamic>>> addCatalogItem({
    required String catalogId,
    required String materialId,
    required String listPrice,
    bool? bonusEligible,
    String? validFrom,
    String? validTo,
  }) async {
    final token = _token;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.addCatalogItem(
      accessToken: token,
      catalogId: catalogId,
      materialId: materialId,
      listPrice: listPrice,
      bonusEligible: bonusEligible,
      validFrom: validFrom,
      validTo: validTo,
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> updateCatalogStatus({
    required String catalogId,
    required String status,
  }) async {
    final token = _token;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.updateCatalogStatus(
      accessToken: token,
      catalogId: catalogId,
      status: status,
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> createAcquisition({
    required String campaignId,
    required String participationId,
    required String catalogId,
    required String acquiredAt,
    required List<Map<String, dynamic>> items,
    String? externalReference,
  }) async {
    final token = _token;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.createAcquisition(
      accessToken: token,
      campaignId: campaignId,
      participationId: participationId,
      catalogId: catalogId,
      acquiredAt: acquiredAt,
      items: items,
      externalReference: externalReference,
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> listCampaignAcquisitions({
    required String campaignId,
    int page = 1,
    int pageSize = 25,
  }) async {
    final token = _token;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.listCampaignAcquisitions(
      accessToken: token,
      campaignId: campaignId,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> updateAcquisitionStatus({
    required String acquisitionId,
    required String status,
    required String resolution,
  }) async {
    final token = _token;
    if (token == null) return const Result.failure('Sin sesión activa.');
    return remoteDataSource.updateAcquisitionStatus(
      accessToken: token,
      acquisitionId: acquisitionId,
      status: status,
      resolution: resolution,
    );
  }

  @override
  Future<Result<List<CatalogMaterial>>> listClubMaterials({
    required String clubId,
    int page = 1,
    int pageSize = 25,
    String? search,
  }) async {
    final token = _token;
    if (token == null) return const Result.failure('Sin sesión activa.');
    final result = await remoteDataSource.listClubMaterials(
      accessToken: token,
      clubId: clubId,
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return result.map((list) => list.map((dto) => dto.toEntity()).toList());
  }

  @override
  Future<Result<List<CatalogAcquisition>>> listMyAcquisitions({
    int page = 1,
    int pageSize = 25,
  }) async {
    final token = _token;
    if (token == null) return const Result.failure('Sin sesión activa.');
    final result = await remoteDataSource.listMyAcquisitions(
      accessToken: token,
      page: page,
      pageSize: pageSize,
    );
    return result.map((list) => list.map((dto) => dto.toEntity()).toList());
  }
}
