import 'package:equatable/equatable.dart';

class WorkspaceClub extends Equatable {
  final String tenantId;
  final String institutionId;
  final String institutionName;
  final String clubId;
  final String clubName;
  final Map<String, dynamic>? membership;
  final List<Map<String, dynamic>> roles;
  final List<String> permissions;
  final List<String> associateGroupIds;

  const WorkspaceClub({
    required this.tenantId,
    required this.institutionId,
    required this.institutionName,
    required this.clubId,
    required this.clubName,
    this.membership,
    this.roles = const [],
    this.permissions = const [],
    this.associateGroupIds = const [],
  });

  @override
  List<Object?> get props => [
    tenantId,
    institutionId,
    institutionName,
    clubId,
    clubName,
    membership,
    roles,
    permissions,
    associateGroupIds,
  ];
}

class Workspace extends Equatable {
  final String accountId;
  final String email;
  final List<WorkspaceClub> clubs;

  const Workspace({
    required this.accountId,
    required this.email,
    this.clubs = const [],
  });

  @override
  List<Object?> get props => [accountId, email, clubs];
}

