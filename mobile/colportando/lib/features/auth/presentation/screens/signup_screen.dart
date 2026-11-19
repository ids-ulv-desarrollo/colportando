import 'package:colportando/core/constants/strings_constants.dart';
import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/domain/entities/invitation.dart';
import 'package:colportando/features/auth/presentation/riverpod/invitation_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Correo, código e invitación de una consulta exitosa; el registro los conserva sin cambios.
class SignupArguments {
  final String email;
  final String code;
  final InvitationPreview invitation;

  const SignupArguments({
    required this.email,
    required this.code,
    required this.invitation,
  });
}

// Pantalla para completar los datos y aceptar la invitación consultada.
class SignupScreen extends ConsumerStatefulWidget {
  // Invitación consultada; es nula si la ruta se abre sin argumentos válidos.
  final SignupArguments? arguments;

  const SignupScreen({super.key, this.arguments});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _givenNamesController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _secondFamilyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  InvitationAcceptance? _acceptance;

  @override
  void dispose() {
    _givenNamesController.dispose();
    _familyNameController.dispose();
    _secondFamilyNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Valida el teléfono opcional con el patrón E.164 del contrato.
  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? "";
    if (phone.isEmpty) return null;
    return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(phone)
        ? null
        : "Usa el formato internacional, por ejemplo +525512345678";
  }

  // Aplica el contrato: de 8 a 256 caracteres, sin recortar espacios.
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return StringsConstants.campoRequerido;
    return value.length < 8
        ? "La contraseña debe tener al menos 8 caracteres"
        : null;
  }

  // La confirmación solo se valida en el formulario; no forma parte de la solicitud.
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return StringsConstants.campoRequerido;
    return value != _passwordController.text
        ? "Las contraseñas no coinciden"
        : null;
  }

  // Convierte un campo opcional vacío en nulo para omitirlo del envío.
  String? _optionalText(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  // Cualquier cambio en los datos inicia una operación nueva con otra clave.
  void _handleFormChanged(String _) =>
      ref.read(acceptInvitationProvider.notifier).startNewOperation();

  // Acepta la invitación con el correo y el código consultados y muestra el resultado confirmado.
  Future<void> _handleAccept(SignupArguments arguments) async {
    final result = await ref
        .read(acceptInvitationProvider.notifier)
        .submit(
          email: arguments.email,
          code: arguments.code,
          password: _passwordController.text,
          givenNames: _givenNamesController.text.trim(),
          familyName: _familyNameController.text.trim(),
          secondFamilyName: _optionalText(_secondFamilyNameController),
          phoneE164: _optionalText(_phoneController),
        );
    if (result == null ||
        !mounted ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }

    if (result.isSuccess) {
      setState(() => _acceptance = result.data);
    } else {
      SnackBarFormat().show(context, result.error!, isError: true);
    }
  }

  // Describe la membresía devuelta por el servidor.
  String _describeMembership(
    InvitationAcceptance acceptance,
    InvitationPreview invitation,
  ) {
    final condition = acceptance.memberCondition == "ASPIRANT"
        ? "aspirante"
        : acceptance.memberCondition;
    final status = acceptance.membershipStatus == "PENDING"
        ? "pendiente"
        : acceptance.membershipStatus;
    return "Tu membresía en ${invitation.clubName} quedó como $condition, con estado $status.";
  }

  // Cambiar el correo o el código exige consultar de nuevo: regresa a la consulta.
  void _handleChangeInvitation() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, GlobalRoute.inspectInvitation);
    }
  }

  // Abre la consulta cuando la pantalla se abrió sin una invitación consultada.
  void _handleOpenInspect() =>
      Navigator.pushReplacementNamed(context, GlobalRoute.inspectInvitation);

  // Lleva al login: regresa a él si ya está en la pila o lo abre si no estaba.
  void _handleGoToSignin() {
    final navigator = Navigator.of(context);
    var isSigninFound = false;
    navigator.popUntil((route) {
      isSigninFound = route.settings.name == GlobalRoute.signin;
      return isSigninFound || route.isFirst;
    });
    if (!isSigninFound) navigator.pushNamed(GlobalRoute.signin);
  }

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
    final operationState = ref.watch(acceptInvitationProvider);
    final arguments = widget.arguments;

    // Sin una invitación consultada no se puede aceptar; se ofrece consultarla.
    if (arguments == null) {
      return ScaffoldFormat(
        titleAppBar: "Crear cuenta",
        children: [
          TextFormat.body(
            "Primero consulta tu invitación con tu correo y código.",
          ),
          AppSpacing.heightMedium,
          ButtonFormat.primary(
            label: "Consultar invitación",
            onPressed: _handleOpenInspect,
          ),
        ],
      );
    }

    final invitation = arguments.invitation;
    final acceptance = _acceptance;

    if (acceptance != null) {
      return ScaffoldFormat(
        titleAppBar: "Crear cuenta",
        children: [
          ContainerFormat(
            children: [
              TextFormat.subtitle("Invitación aceptada"),
              AppSpacing.heightSmall,
              TextFormat.body(_describeMembership(acceptance, invitation)),
              if (acceptance.isEmailVerified)
                TextFormat.body("Tu correo quedó verificado."),
              if (acceptance.isReplayed)
                TextFormat.bodySecondary(
                  "El servidor reconoció un reintento de la misma solicitud.",
                ),
              TextFormat.bodySecondary(
                "La asignación de roles la realiza la administración del club por separado.",
              ),
            ],
          ),
          AppSpacing.heightMedium,
          ButtonFormat.primary(
            label: "Ir a iniciar sesión",
            onPressed: _handleGoToSignin,
          ),
        ],
      );
    }

    return ScaffoldFormat(
      titleAppBar: "Crear cuenta",
      formKey: _formKey,
      children: [
        ContainerFormat(
          children: [
            TextFormat.subtitle(invitation.clubName),
            TextFormat.body(invitation.institutionName),
            AppSpacing.heightSmall,
            TextFormat.bodySecondary("Invitación para ${invitation.emailHint}"),
            TextFormat.body(_formatExpiration(invitation.expiresAt)),
          ],
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _givenNamesController,
          labelText: "Nombre(s)",
          hintText: "Nombre(s)",
          prefixIcon: AppIcon.person,
          maxLength: 120,
          validator: GlobalValidator.validateRequired,
          onChanged: _handleFormChanged,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _familyNameController,
          labelText: "Primer apellido",
          hintText: "Primer apellido",
          prefixIcon: AppIcon.person,
          maxLength: 120,
          validator: GlobalValidator.validateRequired,
          onChanged: _handleFormChanged,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _secondFamilyNameController,
          labelText: "Segundo apellido (opcional)",
          hintText: "Segundo apellido",
          prefixIcon: AppIcon.person,
          maxLength: 120,
          onChanged: _handleFormChanged,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _phoneController,
          labelText: "Teléfono (opcional)",
          hintText: "+525512345678",
          prefixIcon: AppIcon.phone,
          keyboardType: TextInputType.phone,
          maxLength: 16,
          validator: _validatePhone,
          onChanged: _handleFormChanged,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _passwordController,
          labelText: "Contraseña",
          hintText: "••••••••",
          prefixIcon: AppIcon.password,
          maxLength: 256,
          validator: _validatePassword,
          onChanged: _handleFormChanged,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _confirmPasswordController,
          labelText: "Confirmar contraseña",
          hintText: "••••••••",
          prefixIcon: AppIcon.password,
          maxLength: 256,
          validator: _validateConfirmPassword,
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Aceptar invitación",
          formKey: _formKey,
          isLoading: operationState.isLoading,
          onPressed: () => _handleAccept(arguments),
        ),
        if (operationState.isRetryPending) ...[
          AppSpacing.heightSmall,
          TextFormat.bodySecondary(
            "No se pudo confirmar el resultado. Si reintentas sin cambiar los datos, se enviará la misma solicitud.",
          ),
        ],
        AppSpacing.heightSmall,
        ButtonFormat.text(
          label: "Cambiar correo o código",
          onPressed: _handleChangeInvitation,
        ),
      ],
    );
  }
}
