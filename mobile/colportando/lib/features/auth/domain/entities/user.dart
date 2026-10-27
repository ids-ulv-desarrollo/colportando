import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? role;
  final String? status;
  final String? token;
  final DateTime createdAt;
  final DateTime? deletedAt;
  // final TaskSyncStatus? syncStatus; // Para evaluar si está sincronizado en BD local

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.status,
    this.token,
    required this.createdAt,
    this.deletedAt,
  });

  // copyWith permite crear una nueva instancia inmutable con atributos modificados.
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? status,
    String? token,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  // props de equatable permite comparar los valores de los atributos para determinar si dos instancias de una clase son iguales.
  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    status,
    token,
    createdAt,
    deletedAt,
  ];
}
