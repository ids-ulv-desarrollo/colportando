import 'package:equatable/equatable.dart';

// Representa un material o publicación registrado en el tenant del club.
class CatalogMaterial extends Equatable {
  final String materialId;
  final String code;
  final String name;
  final String? category;
  final String status;

  const CatalogMaterial({
    required this.materialId,
    required this.code,
    required this.name,
    this.category,
    required this.status,
  });

  @override
  List<Object?> get props => [materialId, code, name, category, status];
}

// Representa un catálogo oficial con lista de precios inmutable asignado a una campaña.
class CampaignCatalog extends Equatable {
  final String catalogId;
  final String campaignId;
  final String name;
  final String sourceType;
  final String sourceName;
  final String sourceCutAt;
  final String currency;
  final String status;
  final List<Map<String, dynamic>> items;

  const CampaignCatalog({
    required this.catalogId,
    required this.campaignId,
    required this.name,
    required this.sourceType,
    required this.sourceName,
    required this.sourceCutAt,
    required this.currency,
    required this.status,
    this.items = const [],
  });

  @override
  List<Object?> get props => [
    catalogId,
    campaignId,
    name,
    sourceType,
    sourceName,
    sourceCutAt,
    currency,
    status,
    items,
  ];
}

// Representa una asignación o pedido de material para un participante.
class CatalogAcquisition extends Equatable {
  final String acquisitionId;
  final String? campaignId;
  final String participationId;
  final String acquiredAt;
  final String status;
  final String currency;
  final String total;
  final int? itemCount;
  final String? externalReference;

  const CatalogAcquisition({
    required this.acquisitionId,
    this.campaignId,
    required this.participationId,
    required this.acquiredAt,
    required this.status,
    required this.currency,
    required this.total,
    this.itemCount,
    this.externalReference,
  });

  @override
  List<Object?> get props => [
    acquisitionId,
    campaignId,
    participationId,
    acquiredAt,
    status,
    currency,
    total,
    itemCount,
    externalReference,
  ];
}
