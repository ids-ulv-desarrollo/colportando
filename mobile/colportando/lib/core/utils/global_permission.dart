// Acciones operativas protegidas por rol dentro de la app móvil.
enum Permission {
  manageCampaigns,
  validateDeposits,
  manageParticipants,
  manageGroups,
  reviewAcquisitions,
  requestAcquisitions,
  registerSales,
  uploadDeposits,
  viewCredits,
  viewTrainings,
}

// Matriz de permisos por rol (directiva, asociado, colportor).
class RolePermissions {
  RolePermissions._();

  static const Map<String, Set<Permission>> actions = {
    "directiva": {
      Permission.manageCampaigns,
      Permission.validateDeposits,
      Permission.manageParticipants,
      Permission.manageGroups,
      Permission.reviewAcquisitions,
      Permission.viewTrainings,
    },
    "asociado": {
      Permission.manageParticipants,
      Permission.reviewAcquisitions,
      Permission.uploadDeposits,
      Permission.viewCredits,
      Permission.viewTrainings,
    },
    "colportor": {
      Permission.requestAcquisitions,
      Permission.registerSales,
      Permission.uploadDeposits,
      Permission.viewCredits,
      Permission.viewTrainings,
    },
  };

  // Consulta si el rol activo cuenta con un permiso específico.
  static bool has(String? role, Permission permission) {
    if (role == null) return false;
    return actions[role]?.contains(permission) ?? false;
  }
}
