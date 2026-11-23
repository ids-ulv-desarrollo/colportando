const activeCatalogCampaign = 'Campaña activa';
const activeCatalogStatus = 'Activo';
const closedCatalogStatus = 'Cerrado';

class MaterialCatalog {
  final String name;
  final String description;
  final String campaign;
  final String status;
  final List<String> bookIds;
  final List<String> categoryIds;
  final DateTime createdAt;

  const MaterialCatalog({
    required this.name,
    required this.description,
    required this.campaign,
    required this.status,
    required this.bookIds,
    required this.categoryIds,
    required this.createdAt,
  });

  int get bookCount => bookIds.length;
}
