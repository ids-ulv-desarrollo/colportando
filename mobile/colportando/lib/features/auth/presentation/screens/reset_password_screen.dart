import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/password_strength_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla para confirmar el código recibido y definir la nueva contraseña.
class ResetPasswordScreen extends ConsumerStatefulWidget {
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

  // Confirma el cambio y regresa al inicio de sesión.
  Future<void> _handleResetPassword(String email) async {
    final isUpdated = await ref
        .read(authProvider.notifier)
        .confirmPasswordReset(
          email: email,
          code: _codeController.text.trim(),
          newPassword: _newPasswordController.text,
        );
    if (!mounted || !isUpdated) return;

    SnackBarFormat().show(
      context,
      "Contraseña actualizada. Inicia sesión con tu nueva contraseña",
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      GlobalRoute.signin,
      (route) => false,
    );
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
    final email = widget.email ??
        (ModalRoute.of(context)?.settings.arguments as String?) ??
        '';

    return ScaffoldFormat(
      titleAppBar: "Restablecer contraseña",
      formKey: _formKey,
      children: [
        TextFormat.body("Se envió un código a $email."),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _codeController,
          labelText: "Código",
          hintText: "12345678",
          prefixIcon: AppIcon.lockOutline,
          keyboardType: TextInputType.number,
          maxLength: 8,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: GlobalValidator.validateEightDigitCode,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _newPasswordController,
          labelText: "Nueva contraseña",
          hintText: "••••••••",
          prefixIcon: AppIcon.password,
          maxLength: 256,
          validator: GlobalValidator.validatePassword,
        ),
        PasswordStrengthFormat(controller: _newPasswordController),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _confirmPasswordController,
          labelText: "Confirmar contraseña",
          hintText: "••••••••",
          prefixIcon: AppIcon.password,
          maxLength: 256,
          validator: (value) => GlobalValidator.validateConfirmPassword(
            value,
            _newPasswordController.text,
          ),
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Restablecer contraseña",
          formKey: _formKey,
          isLoading: authState.isLoading,
          onPressed: () => _handleResetPassword(email),
        ),
      ],
    );
  }
}
