class ColportorGroup {
  final String id;
  final String name;
  final String assignedZone;
  final String description;
  final String? imagePath;
  final List<String> colporters;
  final String? associate;

  const ColportorGroup({
    required this.id,
    required this.name,
    required this.assignedZone,
    this.description = "",
    this.imagePath,
    this.colporters = const [],
    this.associate,
  });

  ColportorGroup copyWith({
    String? name,
    String? description,
    String? imagePath,
    bool clearImagePath = false,
    List<String>? colporters,
    String? associate,
    bool clearAssociate = false,
  }) {
    return ColportorGroup(
      id: id,
      name: name ?? this.name,
      assignedZone: assignedZone,
      description: description ?? this.description,
      imagePath: clearImagePath ? null : imagePath ?? this.imagePath,
      colporters: colporters ?? this.colporters,
      associate: clearAssociate ? null : associate ?? this.associate,
    );
  }
}
