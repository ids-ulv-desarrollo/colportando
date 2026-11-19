import 'package:colportando/core/constants/strings_constants.dart';
import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/invitation_riverpod.dart';
import 'package:colportando/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla pública para consultar una invitación con el correo y el código recibidos.
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

  // Valida el formato público del código: de 12 a 15 letras, números o guiones.
  String? _validateCode(String? value) {
    final code = value?.trim() ?? "";
    if (code.isEmpty) return StringsConstants.campoRequerido;
    return RegExp(r'^[A-Za-z0-9-]{12,15}$').hasMatch(code)
        ? null
        : "El código debe tener de 12 a 15 letras, números o guiones";
  }

  // Consulta la invitación y abre el registro con el correo y el código consultados.
  Future<void> _handleInspect() async {
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();
    final result = await ref
        .read(inspectInvitationProvider.notifier)
        .inspect(email: email, code: code);
    if (result == null ||
        !mounted ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }

    if (result.isSuccess) {
      Navigator.pushNamed(
        context,
        GlobalRoute.signup,
        arguments: SignupArguments(
          email: email,
          code: code,
          invitation: result.data!,
        ),
      );
    } else {
      SnackBarFormat().show(context, result.error!, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final operationState = ref.watch(inspectInvitationProvider);

    return ScaffoldFormat(
      titleAppBar: "Crear cuenta",
      formKey: _formKey,
      children: [
        TextFormat.body("Ingresa el correo y el código de tu invitación."),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _emailController,
          labelText: "Correo electrónico",
          hintText: "correo@ejemplo.com",
          prefixIcon: AppIcon.email,
          keyboardType: TextInputType.emailAddress,
          maxLength: 320,
          validator: (value) => GlobalValidator.validateEmail(value?.trim()),
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
          validator: _validateCode,
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Consultar invitación",
          formKey: _formKey,
          isLoading: operationState.isLoading,
          onPressed: _handleInspect,
        ),
      ],
    );
  }
}
