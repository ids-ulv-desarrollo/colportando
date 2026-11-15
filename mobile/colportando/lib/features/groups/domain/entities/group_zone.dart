class GroupZone {
  final String id;
  final String name;
  final DateTime createdAt;

  const GroupZone({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  String get formattedCreatedAt {
    final day = createdAt.day.toString().padLeft(2, "0");
    final month = createdAt.month.toString().padLeft(2, "0");
    return "$day/$month/${createdAt.year}";
  }
}
