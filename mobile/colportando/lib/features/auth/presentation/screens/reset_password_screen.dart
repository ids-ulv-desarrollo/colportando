import 'package:colportando/core/constants/strings_constants.dart';
import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla para confirmar el código recibido y definir la contraseña nueva.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  // Correo usado en la solicitud del código; es nulo si la ruta se abre sin argumento.
  final String? email;

  const ResetPasswordScreen({super.key, this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Exige exactamente ocho dígitos; se envía como texto para conservar ceros iniciales.
  String? _validateCode(String? value) {
    if (value == null || value.isEmpty) return StringsConstants.campoRequerido;
    return RegExp(r'^\d{8}$').hasMatch(value)
        ? null
        : "El código debe tener 8 dígitos";
  }

  // Aplica el contrato del backend: de 8 a 256 caracteres, sin recortar espacios.
  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return StringsConstants.campoRequerido;
    return value.length < 8
        ? "La contraseña debe tener al menos 8 caracteres"
        : null;
  }

  // Comprueba que la confirmación coincida exactamente con la contraseña nueva.
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return StringsConstants.campoRequerido;
    return value != _newPasswordController.text
        ? "Las contraseñas no coinciden"
        : null;
  }

  // Confirma el cambio una sola vez y regresa al login tras el éxito.
  Future<void> _handleResetPassword(String email) async {
    if (ref.read(authProvider).isLoading) return;
    final isUpdated = await ref
        .read(authProvider.notifier)
        .confirmPasswordReset(
          email: email,
          code: _codeController.text,
          newPassword: _newPasswordController.text,
        );
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;

    if (!isUpdated) {
      final errorMessage = ref.read(authProvider).errorMessage;
      if (errorMessage != null) {
        SnackBarFormat().show(context, errorMessage, isError: true);
      }
      return;
    }
    SnackBarFormat().show(
      context,
      "Contraseña actualizada. Inicia sesión con tu nueva contraseña",
    );
    Navigator.popUntil(
      context,
      (route) => route.settings.name == GlobalRoute.signin || route.isFirst,
    );
  }

  // Vuelve a la solicitud del código: regresa si viene de ella o la abre si falta el correo.
  void _handleRequestNewCode() {
    if (widget.email != null && Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, GlobalRoute.forgotPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final email = widget.email;

    // Sin correo no se puede confirmar el cambio; se ofrece solicitar un código.
    if (email == null || email.isEmpty) {
      return ScaffoldFormat(
        titleAppBar: "Restablecer contraseña",
        children: [
          TextFormat.body("Primero solicita un código de recuperación."),
          AppSpacing.heightMedium,
          ButtonFormat.primary(
            label: "Solicitar código",
            onPressed: _handleRequestNewCode,
          ),
        ],
      );
    }

    return ScaffoldFormat(
      titleAppBar: "Restablecer contraseña",
      formKey: _formKey,
      children: [
        TextFormat.body("Se enviará un código a $email."),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _codeController,
          labelText: "Código",
          hintText: "12345678",
          prefixIcon: AppIcon.lockOutline,
          keyboardType: TextInputType.number,
          maxLength: 8,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: _validateCode,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _newPasswordController,
          labelText: "Nueva contraseña",
          hintText: "••••••••",
          prefixIcon: AppIcon.password,
          maxLength: 256,
          validator: _validateNewPassword,
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
          label: "Restablecer contraseña",
          formKey: _formKey,
          isLoading: authState.isLoading,
          onPressed: () => _handleResetPassword(email),
        ),
        AppSpacing.heightSmall,
        ButtonFormat.text(
          label: "Solicitar otro código",
          onPressed: _handleRequestNewCode,
        ),
      ],
    );
  }
}
