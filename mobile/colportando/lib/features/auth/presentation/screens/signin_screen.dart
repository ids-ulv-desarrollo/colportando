import 'package:colportando/core/constants/strings_constants.dart';
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

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Envía las credenciales una sola vez y reacciona solo al resultado de este intento.
  Future<void> _handleLogin() async {
    if (ref.read(authProvider).isLoading) return;
    await ref
        .read(authProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;

    final authState = ref.read(authProvider);
    if (authState.isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        GlobalRoute.mainNavigation,
        (route) => false,
      );
    } else if (authState.errorMessage != null) {
      SnackBarFormat().show(context, authState.errorMessage!, isError: true);
    }
  }

  // Abre la solicitud del código de recuperación.
  void _handleForgotPassword() =>
      Navigator.pushNamed(context, GlobalRoute.forgotPassword);

  // Inicia el registro por invitación consultando primero el correo y el código.
  void _handleCreateAccount() {
    if (ref.read(authProvider).isLoading) return;
    Navigator.pushNamed(context, GlobalRoute.inspectInvitation);
  }

  // Exige al menos un carácter sin recortar espacios; la complejidad se valida al crear o cambiar la contraseña.
  String? _validatePassword(String? value) =>
      (value == null || value.isEmpty) ? StringsConstants.campoRequerido : null;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return ScaffoldFormat(
      titleAppBar: "Iniciar Sesión",
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
        InputTextFormart(
          controller: _passwordController,
          labelText: "Contraseña",
          hintText: "••••••••",
          prefixIcon: AppIcon.password,
          maxLength: 256,
          validator: _validatePassword,
        ),
        // Enlace alineado a la derecha; se desactiva mientras hay una operación en curso.
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: authState.isLoading ? null : _handleForgotPassword,
            child: const Text("¿Olvidaste tu contraseña?"),
          ),
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Iniciar Sesión",
          formKey: _formKey,
          isLoading: authState.isLoading,
          onPressed: _handleLogin,
        ),
        AppSpacing.heightSmall,
        ButtonFormat.text(
          label: "Crear cuenta",
          onPressed: _handleCreateAccount,
        ),
      ],
    );
  }
}
