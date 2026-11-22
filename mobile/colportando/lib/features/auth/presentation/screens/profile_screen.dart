import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/circular_loading.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/workspace/domain/entities/workspace.dart';
import 'package:colportando/features/workspace/presentation/riverpod/workspace_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Perfil de la cuenta autenticada a partir del contexto de Workspace.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const Map<String, String> _membershipStatusLabels = {
    "PENDING": "Pendiente",
    "ACTIVE": "Activa",
    "SUSPENDED": "Suspendida",
    "ENDED": "Finalizada",
  };

  static const Map<String, String> _memberConditionLabels = {
    "ASPIRANT": "Aspirante",
    "COLPORTOR": "Colportor",
  };

  // Cierra la sesión activa y muestra la notificación.
  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authProvider.notifier).signOut();
    if (!context.mounted) return;
    SnackBarFormat().show(context, "Sesión cerrada correctamente");
  }

  // Sección de un club con su institución, membresía y roles asignados.
  Widget _buildClubSection(WorkspaceClub club) {
    final membership = club.membership;
    final status = _membershipStatusLabels[membership?["status"]] ??
        membership?["status"]?.toString() ??
        "No especificado";
    final condition = _memberConditionLabels[membership?["condition"]] ??
        membership?["condition"]?.toString() ??
        "No especificado";

    return ContainerFormat(
      children: [
        TextFormat.subtitle(club.clubName),
        TextFormat.body("Institución: ${club.institutionName}"),
        AppSpacing.heightSmall,
        if (membership == null)
          TextFormat.body("Membresía: Sin membresía")
        else ...[
          TextFormat.body("Estado de membresía: $status"),
          TextFormat.body("Condición: $condition"),
        ],
        AppSpacing.heightSmall,
        TextFormat.label("Rol"),
        if (club.roles.isEmpty)
          TextFormat.bodySecondary("Sin roles asignados")
        else
          for (final role in club.roles)
            TextFormat.body(role["name"]?.toString() ?? "No especificado"),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<WorkspaceState>(workspaceProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        SnackBarFormat().show(context, next.errorMessage!, isError: true);
      }
    });

    final workspace = ref.watch(workspaceProvider).workspace;

    if (workspace == null) {
      return const ScaffoldFormat(
        titleAppBar: "Perfil",
        children: [Center(child: CircularLoading())],
      );
    }

    return ScaffoldFormat(
      titleAppBar: "Perfil",
      children: [
        TextFormat.label("Correo electrónico"),
        TextFormat.body(workspace.email),
        AppSpacing.heightMedium,
        if (workspace.clubs.isEmpty)
          TextFormat.bodySecondary("Sin clubes disponibles")
        else
          for (final club in workspace.clubs) _buildClubSection(club),
        AppSpacing.heightMedium,
        ContainerListTile(
          title: "Cambiar contraseña",
          icon: AppIcon.lockOutline,
          onPressed: () =>
              Navigator.pushNamed(context, GlobalRoute.forgotPassword),
        ),
        AppSpacing.heightMedium,
        ContainerListTile(
          title: "Cerrar sesión",
          icon: AppIcon.logoutOutlined,
          onPressed: () => _handleSignOut(context, ref),
        ),
        AppSpacing.heightMedium,
        ContainerListTile(
          title: "Invitar aspirante",
          icon: AppIcon.person,
          onPressed: () =>
              Navigator.pushNamed(context, GlobalRoute.createInvitation),
        ),
      ],
    );
  }
}
