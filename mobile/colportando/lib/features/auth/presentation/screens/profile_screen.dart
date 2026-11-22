import 'package:colportando/core/constants/strings_constants.dart';
import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/circular_loading.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/workspace/domain/entities/workspace.dart';
import 'package:colportando/features/workspace/presentation/riverpod/workspace_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Perfil de la cuenta autenticada a partir del contexto de Workspace.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
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

  Workspace? _workspace;
  String? _errorMessage;
  bool _isLoading = true;
  // Identifica la consulta vigente; las respuestas de consultas anteriores se descartan.
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    // Se difiere la carga porque Riverpod no permite modificar estado mientras se construye el árbol.
    Future.microtask(_loadContext);
  }

  // Cuenta de la sesión activa, o null si no hay sesión.
  String? _currentAccountId() {
    final authState = ref.read(authProvider);
    return authState.isAuthenticated ? authState.user?.id : null;
  }

  // Consulta el contexto y solo lo conserva si pertenece a la misma cuenta que lo pidió.
  Future<void> _loadContext() async {
    if (!mounted) return;
    final requestId = ++_requestId;
    final accountId = _currentAccountId();
    setState(() {
      _isLoading = accountId != null;
      _workspace = null;
      _errorMessage = null;
    });
    if (accountId == null) return;

    await ref.read(workspaceProvider.notifier).getContext();
    if (!mounted || requestId != _requestId) return;

    final workspaceState = ref.read(workspaceProvider);
    final workspace = workspaceState.workspace;
    setState(() {
      _isLoading = false;
      if (workspaceState.errorMessage != null) {
        _errorMessage = workspaceState.errorMessage;
      } else if (workspace == null ||
          workspace.accountId != accountId ||
          _currentAccountId() != accountId) {
        _errorMessage =
            "Los datos recibidos no corresponden a la sesión actual. Vuelve a intentarlo.";
      } else {
        _workspace = workspace;
      }
    });
  }

  // Reintenta la consulta si no hay otra en curso.
  void _handleRetry() {
    if (_isLoading) return;
    _loadContext();
  }

  // Devuelve el texto recibido sin espacios sobrantes, o null si falta o está vacío.
  String? _readText(Object? value) {
    if (value is! String) return null;
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  // Traduce los valores conocidos; muestra los desconocidos tal cual y "No especificado" si faltan.
  String _describeValue(Object? value, Map<String, String> labels) {
    final text = _readText(value);
    if (text == null) return "No especificado";
    return labels[text] ?? text;
  }

  // Sección de un club con su institución, membresía y todos sus roles.
  Widget _buildClubSection(WorkspaceClub club) {
    final membership = club.membership;
    final roleNames = club.roles
        .map((role) => _readText(role["name"]) ?? "No especificado")
        .toList();
    return ContainerFormat(
      children: [
        TextFormat.subtitle(club.clubName),
        TextFormat.body("Institución: ${club.institutionName}"),
        AppSpacing.heightSmall,
        if (membership == null)
          TextFormat.body("Membresía: Sin membresía")
        else ...[
          TextFormat.body(
            "Estado de membresía: ${_describeValue(membership["status"], _membershipStatusLabels)}",
          ),
          TextFormat.body(
            "Condición: ${_describeValue(membership["condition"], _memberConditionLabels)}",
          ),
        ],
        AppSpacing.heightSmall,
        TextFormat.label("Rol"),
        if (roleNames.isEmpty)
          TextFormat.bodySecondary("Sin roles asignados")
        else
          for (final roleName in roleNames) TextFormat.body(roleName),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final accountId = authState.isAuthenticated ? authState.user?.id : null;

    if (accountId == null) {
      return ScaffoldFormat(
        titleAppBar: "Perfil",
        children: [TextFormat.body("Inicia sesión para ver tu perfil.")],
      );
    }

    if (_isLoading) {
      return const ScaffoldFormat(
        titleAppBar: "Perfil",
        children: [Center(child: CircularLoading())],
      );
    }

    // Un error, o datos de otra cuenta, nunca se presentan como perfil vacío.
    final workspace = _workspace;
    if (_errorMessage != null ||
        workspace == null ||
        workspace.accountId != accountId) {
      return ScaffoldFormat(
        titleAppBar: "Perfil",
        children: [
          TextFormat.body(
            _errorMessage ??
                "Los datos cargados no corresponden a la sesión actual.",
          ),
          AppSpacing.heightMedium,
          ButtonFormat.secondary(
            label: StringsConstants.retry,
            onPressed: _handleRetry,
          ),
        ],
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
          for (final club in workspace.clubs) ...[
            _buildClubSection(club),
            AppSpacing.heightMedium,
          ],
        AppSpacing.heightMedium,
        // El servidor decide por club si la cuenta puede invitar.
        ButtonFormat.secondary(
          label: "Invitar aspirante",
          onPressed: () =>
              Navigator.pushNamed(context, GlobalRoute.createInvitation),
        ),
      ],
    );
  }
}
