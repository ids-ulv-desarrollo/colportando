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

  // Método para manejar el inicio de sesión.
  void _handleLogin() => ref
      .read(authProvider.notifier)
      .login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

  @override
  Widget build(BuildContext context) {
    // No redibuja la vista; se ejecuta algo puntual (mostrar alertas) cuando el estado cambia.
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage != null) {
        SnackBarFormat().show(context, next.errorMessage!, isError: true);
      }
    });

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
          maxLength: 100,
          validator: GlobalValidator.validateEmail,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _passwordController,
          labelText: "Contraseña",
          hintText: "••••••••",
          prefixIcon: AppIcon.password,
          maxLength: 50,
          validator: GlobalValidator.validatePassword,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: authState.isLoading
                ? null
                : () =>
                      Navigator.pushNamed(context, GlobalRoute.forgotPassword),
            child: const Text("¿Olvidaste tu contraseña?"),
          ),
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          icon: AppIcon.doneAll,
          label: "Iniciar Sesión",
          formKey: _formKey,
          isLoading: authState.isLoading,
          onPressed: _handleLogin,
        ),
        AppSpacing.heightSmall,
        ButtonFormat.text(
          label: "Crear cuenta",
          onPressed: () =>
              Navigator.pushNamed(context, GlobalRoute.inspectInvitation),
        ),
      ],
    );
  }
}
