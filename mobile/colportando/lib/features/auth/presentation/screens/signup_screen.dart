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
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Argumentos recibidos desde la consulta de invitación.
class SignupArguments {
  final String email;
  final String code;
  final String? clubName;

  const SignupArguments({
    required this.email,
    required this.code,
    this.clubName,
  });
}

// Pantalla para completar el registro y aceptar la invitación.
class SignupScreen extends ConsumerStatefulWidget {
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

  // Completa el registro y redirige al inicio de sesión.
  Future<void> _handleSignup(SignupArguments args) async {
    final secondName = _secondFamilyNameController.text.trim();
    final phone = _phoneController.text.trim();

    final result = await ref
        .read(authProvider.notifier)
        .acceptInvitation(
          email: args.email,
          code: args.code,
          password: _passwordController.text,
          givenNames: _givenNamesController.text.trim(),
          familyName: _familyNameController.text.trim(),
          secondFamilyName: secondName.isEmpty ? null : secondName,
          phoneE164: phone.isEmpty ? null : phone,
        );
    if (!mounted) return;

    if (result != null) {
      SnackBarFormat().show(
        context,
        "Registro completado. Ya puedes iniciar sesión",
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        GlobalRoute.signin,
        (route) => false,
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
    final args =
        widget.arguments ??
        (ModalRoute.of(context)?.settings.arguments as SignupArguments?) ??
        const SignupArguments(email: '', code: '');

    return ScaffoldFormat(
      titleAppBar: "Crear cuenta",
      formKey: _formKey,
      children: [
        if (args.clubName != null && args.clubName!.isNotEmpty) ...[
          TextFormat.subtitle("Club: ${args.clubName}"),
          AppSpacing.heightSmall,
        ],
        TextFormat.body("Completa tus datos para activar tu cuenta."),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _givenNamesController,
          labelText: "Nombre(s)",
          hintText: "Tu nombre",
          prefixIcon: AppIcon.person,
          maxLength: 120,
          validator: GlobalValidator.validateRequired,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _familyNameController,
          labelText: "Primer apellido",
          hintText: "Tu primer apellido",
          prefixIcon: AppIcon.person,
          maxLength: 120,
          validator: GlobalValidator.validateRequired,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _secondFamilyNameController,
          labelText: "Segundo apellido (opcional)",
          hintText: "Tu segundo apellido",
          prefixIcon: AppIcon.person,
          maxLength: 120,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _phoneController,
          labelText: "Teléfono (opcional)",
          hintText: "+525512345678",
          prefixIcon: AppIcon.phone,
          keyboardType: TextInputType.phone,
          maxLength: 16,
          validator: GlobalValidator.validatePhone,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _passwordController,
          labelText: "Contraseña",
          hintText: "••••••••",
          prefixIcon: AppIcon.password,
          maxLength: 256,
          validator: GlobalValidator.validatePassword,
        ),
        PasswordStrengthFormat(controller: _passwordController),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _confirmPasswordController,
          labelText: "Confirmar contraseña",
          hintText: "••••••••",
          prefixIcon: AppIcon.password,
          maxLength: 256,
          validator: (value) => GlobalValidator.validateConfirmPassword(
            value,
            _passwordController.text,
          ),
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Registrarse",
          formKey: _formKey,
          isLoading: authState.isLoading,
          onPressed: () => _handleSignup(args),
        ),
      ],
    );
  }
}
