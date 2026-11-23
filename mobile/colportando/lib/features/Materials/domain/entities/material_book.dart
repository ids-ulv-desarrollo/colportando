class MaterialBook {
  final String name;
  final String description;
  final String? coverPath;
  final String category;
  final List<String> resourcePaths;
  final bool isBonus;
  final bool isFavorite;
  final DateTime createdAt;
  final bool isActive;

  const MaterialBook({
    required this.name,
    required this.description,
    required this.category,
    this.coverPath,
    this.resourcePaths = const [],
    this.isBonus = false,
    this.isFavorite = false,
    required this.createdAt,
    this.isActive = true,
  });

  String get status => isActive
      ? (isBonus ? bonificableStatus : noBonificableStatus)
      : inactiveBookStatus;

  MaterialBook copyWith({bool? isFavorite, String? category}) {
    return MaterialBook(
      name: name,
      description: description,
      category: category ?? this.category,
      coverPath: coverPath,
      resourcePaths: resourcePaths,
      isBonus: isBonus,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
      isActive: isActive,
    );
  }
}

const bonificableStatus = 'Bonificable';
const noBonificableStatus = 'No bonificable';
const inactiveBookStatus = 'Desactivado';
