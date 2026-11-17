import 'package:equatable/equatable.dart';

class Campaign extends Equatable {
  final String clubId;
  final String name;
  final String? description;
  final DateTime startsOn;
  final DateTime endsOn;
  final DateTime createdAt;
  final DateTime? deletedAt;

  const Campaign({
    required this.clubId,
    required this.name,
    this.description,
    required this.startsOn,
    required this.endsOn,
    required this.createdAt,
    this.deletedAt,
  });

  Campaign copyWith({
    String? clubId,
    String? name,
    String? description,
    DateTime? startsOn,
    DateTime? endsOn,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return Campaign(
      clubId: clubId ?? this.clubId,
      name: name ?? this.name,
      description: description ?? this.description,
      startsOn: startsOn ?? this.startsOn,
      endsOn: endsOn ?? this.endsOn,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt
    );
  }

  @override
  List<Object?> get props => [
    clubId,
    name,
    description,
    startsOn,
    endsOn,
    createdAt,
    deletedAt,
  ];
}