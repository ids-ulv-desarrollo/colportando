import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla para consultar una invitación recibida.
class InspectInvitationScreen extends ConsumerStatefulWidget {
  const InspectInvitationScreen({super.key});

  @override
  ConsumerState<InspectInvitationScreen> createState() =>
      _InspectInvitationScreenState();
}

class _InspectInvitationScreenState
    extends ConsumerState<InspectInvitationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  // Consulta la invitación y abre la pantalla de registro.
  Future<void> _handleInspect() async {
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();
    final info = await ref
        .read(authProvider.notifier)
        .inspectInvitation(email: email, code: code);
    if (!mounted) return;

    if (info != null) {
      Navigator.pushNamed(
        context,
        GlobalRoute.signup,
        arguments: SignupArguments(
          email: email,
          code: code,
          clubName: info['clubName']?.toString(),
        ),
      );
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

    return ScaffoldFormat(
      titleAppBar: "Consultar invitación",
      formKey: _formKey,
      children: [
        TextFormat.body("Ingresa el correo y código de tu invitación."),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _emailController,
          labelText: "Correo electrónico",
          hintText: "correo@ejemplo.com",
          prefixIcon: AppIcon.email,
          keyboardType: TextInputType.emailAddress,
          maxLength: 320,
          validator: GlobalValidator.validateEmail,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _codeController,
          labelText: "Código de invitación",
          hintText: "ABCD-1234-EFGH",
          prefixIcon: AppIcon.lockOutline,
          maxLength: 15,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9-]')),
          ],
          validator: GlobalValidator.validateInvitationCode,
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Consultar invitación",
          formKey: _formKey,
          isLoading: authState.isLoading,
          onPressed: _handleInspect,
        ),
      ],
    );
  }
}
