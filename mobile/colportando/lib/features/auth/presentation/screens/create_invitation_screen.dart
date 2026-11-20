import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/workspace/presentation/riverpod/workspace_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla para enviar una invitación a un aspirante.
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
  String? _selectedClubId;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Envía la invitación del club al correo ingresado.
  Future<void> _handleSendInvitation() async {
    final clubId = _selectedClubId;
    if (clubId == null) return;

    final isSent = await ref
        .read(authProvider.notifier)
        .createInvitation(clubId: clubId, email: _emailController.text.trim());
    if (!mounted) return;

    if (isSent != null) {
      SnackBarFormat().show(context, "Invitación enviada con éxito");
      _emailController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        SnackBarFormat().show(context, next.errorMessage!, isError: true);
      }
    });

    final authState = ref.watch(authProvider);
    final workspace = ref.watch(workspaceProvider).workspace;
    final clubs = workspace?.clubs ?? const [];

    return ScaffoldFormat(
      titleAppBar: "Invitar aspirante",
      formKey: _formKey,
      children: [
        TextFormat.body(
          "Selecciona el club e ingresa el correo del aspirante.",
        ),
        AppSpacing.heightMedium,
        DropdownFormat<String>(
          labelText: "Club",
          hintText: "Selecciona un club",
          prefixIcon: AppIcon.home,
          value:
              _selectedClubId ?? (clubs.isNotEmpty ? clubs.first.clubId : null),
          items: clubs
              .map(
                (club) => DropdownMenuItem(
                  value: club.clubId,
                  child: TextFormat.body(
                    "${club.clubName} · ${club.institutionName}",
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedClubId = value),
          validator: GlobalValidator.validateRequired,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _emailController,
          labelText: "Correo del aspirante",
          hintText: "correo@ejemplo.com",
          prefixIcon: AppIcon.email,
          keyboardType: TextInputType.emailAddress,
          maxLength: 320,
          validator: GlobalValidator.validateEmail,
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Enviar invitación",
          formKey: _formKey,
          isLoading: authState.isLoading,
          onPressed: _handleSendInvitation,
        ),
      ],
    );
  }
}
