import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla informativa para usuarios a la espera de asignación de rol.
class WaitingRoleScreen extends StatelessWidget {
  const WaitingRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      mainAxisAlignment: .center,
      children: [
        TextFormat.title("Bienvenido a Colportando", alignCenter: true),
        AppSpacing.heightSmall,
        TextFormat.body(
          "Espera a que el administrador te asigne tu rol.",
          alignCenter: true,
        ),
      ],
    );
  }
}
