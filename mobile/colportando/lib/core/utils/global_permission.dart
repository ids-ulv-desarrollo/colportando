// Se define las acciones protegidas de la app.
enum Permission {
  // Aquí se definirá las acciones que están protegidas por permisos, las que puedan hacer todos no (signin, signup, etc). Ejemplo:
  editUser,
}

// Se define los permisos que tiene cada rol.
class RolePermissions {
  RolePermissions._();

  static const Map<String, Set<Permission>> actions = {
    "asociado": {
      //Permission.
    },
    "colportor": {},
    "administrador": {},
  };

  // Consulta si un rol tiene un permiso específico.
  static bool has(String? role, Permission permission) {
    if (role == null) return false;
    return actions[role]?.contains(permission) ?? false;
  }
}

// Ejemplo de uso:
// final role = ref.watch(authProvider).user?.role;
// final canEdit = RolePermissions.has(role, Permission.editUser);
