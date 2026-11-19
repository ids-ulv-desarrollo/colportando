import 'package:colportando/core/constants/strings_constants.dart';
import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/circular_loading.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/domain/entities/invitation.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/auth/presentation/riverpod/invitation_riverpod.dart';
import 'package:colportando/features/workspace/domain/entities/workspace.dart';
import 'package:colportando/features/workspace/presentation/riverpod/workspace_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla autenticada para invitar a un aspirante a uno de los clubes de la cuenta actual.
class CreateInvitationScreen extends ConsumerStatefulWidget {
  const CreateInvitationScreen({super.key});

  @override
  ConsumerState<CreateInvitationScreen> createState() =>
      _CreateInvitationScreenState();
}

class _CreateInvitationScreenState
    extends ConsumerState<CreateInvitationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  List<WorkspaceClub> _clubs = const [];
  String? _selectedClubId;
  String? _loadErrorMessage;
  bool _isLoadingClubs = true;
  InvitationReceipt? _receipt;
  String? _receiptEmail;

  @override
  void initState() {
    super.initState();
    // Se difiere la carga porque Riverpod no permite modificar estado mientras se construye el árbol.
    Future.microtask(_loadClubs);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Consulta el contexto de Workspace y comprueba que pertenezca a la cuenta autenticada.
  Future<void> _loadClubs() async {
    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated || authState.user == null) {
      setState(() => _isLoadingClubs = false);
      return;
    }
    await ref.read(workspaceProvider.notifier).getContext();
    if (!mounted) return;

    final workspaceState = ref.read(workspaceProvider);
    final workspace = workspaceState.workspace;
    final currentAccountId = ref.read(authProvider).user?.id;
    setState(() {
      _isLoadingClubs = false;
      if (workspaceState.errorMessage != null) {
        _loadErrorMessage = workspaceState.errorMessage;
      } else if (workspace == null || workspace.accountId != currentAccountId) {
        _loadErrorMessage =
            "Los clubes recibidos no corresponden a la sesión actual. Vuelve a iniciar sesión.";
      } else {
        _loadErrorMessage = null;
        _clubs = workspace.clubs;
        if (!_clubs.any((club) => club.clubId == _selectedClubId)) {
          _selectedClubId = null;
        }
      }
    });
  }

  // Reintenta la carga de clubes si no hay otra en curso.
  void _handleRetryLoad() {
    if (_isLoadingClubs) return;
    setState(() {
      _isLoadingClubs = true;
      _loadErrorMessage = null;
    });
    _loadClubs();
  }

  // Un cambio en el club o el correo inicia una operación nueva con otra clave.
  void _handleFormChanged() =>
      ref.read(createInvitationProvider.notifier).startNewOperation();

  // Envía la invitación y muestra el resultado confirmado por el servidor.
  Future<void> _handleSendInvitation() async {
    final clubId = _selectedClubId;
    if (clubId == null) return;
    final email = _emailController.text.trim();
    final result = await ref
        .read(createInvitationProvider.notifier)
        .submit(clubId: clubId, email: email);
    if (result == null ||
        !mounted ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }

    if (result.isSuccess) {
      setState(() {
        _receipt = result.data;
        _receiptEmail = email;
      });
    } else {
      SnackBarFormat().show(context, result.error!, isError: true);
    }
  }

  // Muestra en español el estado devuelto por el servidor cuando es un valor conocido.
  String _describeStatus(String status) =>
      status == "PENDING" ? "Pendiente" : status;

  // Muestra en hora local el vencimiento devuelto por el servidor.
  String _formatExpiration(DateTime expiresAt) {
    final local = expiresAt.toLocal();
    final day = local.day.toString().padLeft(2, "0");
    final month = local.month.toString().padLeft(2, "0");
    final hour = local.hour.toString().padLeft(2, "0");
    final minute = local.minute.toString().padLeft(2, "0");
    return "Vence el $day/$month/${local.year} a las $hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final operationState = ref.watch(createInvitationProvider);

    // Enviar invitaciones requiere una sesión activa.
    if (!authState.isAuthenticated || authState.user == null) {
      return ScaffoldFormat(
        titleAppBar: "Invitar aspirante",
        children: [
          TextFormat.body("Inicia sesión para enviar invitaciones."),
          AppSpacing.heightMedium,
          ButtonFormat.primary(
            label: "Ir a iniciar sesión",
            onPressed: () => Navigator.pushNamed(context, GlobalRoute.signin),
          ),
        ],
      );
    }

    if (_isLoadingClubs) {
      return const ScaffoldFormat(
        titleAppBar: "Invitar aspirante",
        children: [Center(child: CircularLoading())],
      );
    }

    if (_loadErrorMessage != null || _clubs.isEmpty) {
      return ScaffoldFormat(
        titleAppBar: "Invitar aspirante",
        children: [
          TextFormat.body(
            _loadErrorMessage ??
                "Tu contexto de trabajo no incluye clubes para enviar invitaciones.",
          ),
          AppSpacing.heightMedium,
          ButtonFormat.secondary(
            label: StringsConstants.retry,
            onPressed: _handleRetryLoad,
          ),
        ],
      );
    }

    final receipt = _receipt;
    return ScaffoldFormat(
      titleAppBar: "Invitar aspirante",
      formKey: _formKey,
      children: [
        DropdownFormat<String>(
          labelText: "Club",
          hintText: "Selecciona un club",
          prefixIcon: AppIcon.home,
          value: _selectedClubId,
          items: _clubs
              .map(
                (club) => DropdownMenuItem(
                  value: club.clubId,
                  child: TextFormat.body(
                    "${club.clubName} · ${club.institutionName}",
                  ),
                ),
              )
              .toList(),
          onChanged: operationState.isLoading
              ? null
              : (value) {
                  setState(() => _selectedClubId = value);
                  _handleFormChanged();
                },
          validator: (value) =>
              value == null ? StringsConstants.campoRequerido : null,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _emailController,
          labelText: "Correo del aspirante",
          hintText: "correo@ejemplo.com",
          prefixIcon: AppIcon.email,
          keyboardType: TextInputType.emailAddress,
          maxLength: 320,
          validator: (value) => GlobalValidator.validateEmail(value?.trim()),
          onChanged: (_) => _handleFormChanged(),
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Enviar invitación",
          formKey: _formKey,
          isLoading: operationState.isLoading,
          onPressed: _handleSendInvitation,
        ),
        if (operationState.isRetryPending) ...[
          AppSpacing.heightSmall,
          TextFormat.bodySecondary(
            "No se pudo confirmar el resultado. Si reintentas sin cambiar los datos, se enviará la misma solicitud.",
          ),
        ],
        if (receipt != null) ...[
          AppSpacing.heightMedium,
          ContainerFormat(
            children: [
              TextFormat.subtitle("Invitación creada"),
              AppSpacing.heightSmall,
              TextFormat.body("Correo: $_receiptEmail"),
              TextFormat.body("Estado: ${_describeStatus(receipt.status)}"),
              TextFormat.body(_formatExpiration(receipt.expiresAt)),
              if (receipt.isReplayed)
                TextFormat.bodySecondary(
                  "El servidor reconoció un reintento de la misma solicitud.",
                ),
            ],
          ),
        ],
      ],
    );
  }
}
