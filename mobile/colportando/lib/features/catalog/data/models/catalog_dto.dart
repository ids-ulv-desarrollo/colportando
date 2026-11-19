import 'package:colportando/features/catalog/domain/entities/catalog.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_dto.freezed.dart';
part 'catalog_dto.g.dart';

@freezed
abstract class CatalogMaterialDto with _$CatalogMaterialDto {
  // Constructor privado necesario para poder agregar métodos propios (toEntity).
  const CatalogMaterialDto._();

  const factory CatalogMaterialDto({
    required String materialId,
    required String code,
    required String name,
    String? category,
    required String status,
  }) = _CatalogMaterialDto;

  // Conecta la serialización JSON automática.
  factory CatalogMaterialDto.fromJson(Map<String, dynamic> json) =>
      _$CatalogMaterialDtoFromJson(json);

  // Convierte el DTO a la entidad inmutable del dominio.
  CatalogMaterial toEntity() => CatalogMaterial(
    materialId: materialId,
    code: code,
    name: name,
    category: category,
    status: status,
  );
}

@freezed
abstract class CampaignCatalogDto with _$CampaignCatalogDto {
  // Constructor privado necesario para poder agregar métodos propios (toEntity).
  const CampaignCatalogDto._();

  const factory CampaignCatalogDto({
    required String catalogId,
    required String campaignId,
    required String name,
    required String sourceType,
    required String sourceName,
    required String sourceCutAt,
    required String currency,
    required String status,
    @Default([]) List<Map<String, dynamic>> items,
  }) = _CampaignCatalogDto;

  // Conecta la serialización JSON automática.
  factory CampaignCatalogDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignCatalogDtoFromJson(json);

  // Convierte el DTO a la entidad inmutable del dominio.
  CampaignCatalog toEntity() => CampaignCatalog(
    catalogId: catalogId,
    campaignId: campaignId,
    name: name,
    sourceType: sourceType,
    sourceName: sourceName,
    sourceCutAt: sourceCutAt,
    currency: currency,
    status: status,
    items: items,
  );
}

@freezed
abstract class CatalogAcquisitionDto with _$CatalogAcquisitionDto {
  // Constructor privado necesario para poder agregar métodos propios (toEntity).
  const CatalogAcquisitionDto._();

  const factory CatalogAcquisitionDto({
    required String acquisitionId,
    String? campaignId,
    required String participationId,
    required String acquiredAt,
    required String status,
    required String currency,
    required String total,
    int? itemCount,
    String? externalReference,
  }) = _CatalogAcquisitionDto;

  // Conecta la serialización JSON automática.
  factory CatalogAcquisitionDto.fromJson(Map<String, dynamic> json) =>
      _$CatalogAcquisitionDtoFromJson(json);

  // Convierte el DTO a la entidad inmutable del dominio.
  CatalogAcquisition toEntity() => CatalogAcquisition(
    acquisitionId: acquisitionId,
    campaignId: campaignId,
    participationId: participationId,
    acquiredAt: acquiredAt,
    status: status,
    currency: currency,
    total: total,
    itemCount: itemCount,
    externalReference: externalReference,
  );
}
