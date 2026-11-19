import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla para solicitar el código de recuperación de contraseña.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Solicita el código una sola vez y abre el restablecimiento con el correo usado.
  Future<void> _handleRequestCode() async {
    if (ref.read(authProvider).isLoading) return;
    final email = _emailController.text.trim();
    final isRequested = await ref
        .read(authProvider.notifier)
        .requestPasswordReset(email: email);
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;

    if (isRequested) {
      Navigator.pushNamed(context, GlobalRoute.resetPassword, arguments: email);
      return;
    }
    final errorMessage = ref.read(authProvider).errorMessage;
    if (errorMessage != null) {
      SnackBarFormat().show(context, errorMessage, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return ScaffoldFormat(
      titleAppBar: "Recuperar contraseña",
      formKey: _formKey,
      children: [
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
        ButtonFormat.primary(
          label: "Enviar código",
          formKey: _formKey,
          isLoading: authState.isLoading,
          onPressed: _handleRequestCode,
        ),
      ],
    );
  }
}
