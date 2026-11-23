const activeCategoryStatus = 'Activa';
const inactiveCategoryStatus = 'Desactivada';

class MaterialCategory {
  final String name;
  final String description;
  final List<String> bookIds;
  final String status;
  final DateTime createdAt;

  const MaterialCategory({
    required this.name,
    required this.description,
    required this.bookIds,
    required this.status,
    required this.createdAt,
  });

  int get bookCount => bookIds.length;
}
