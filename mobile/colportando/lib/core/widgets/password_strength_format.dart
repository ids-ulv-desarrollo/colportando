import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Widget para visualizar el nivel de seguridad de una contraseña mediante una barra dinámica.
class PasswordStrengthFormat extends StatelessWidget {
  final TextEditingController? controller;
  final String? password;

  const PasswordStrengthFormat({
    super.key,
    this.controller,
    this.password,
  }) : assert(
          controller != null || password != null,
          'Debes proporcionar un controller o password.',
        );

  (double percent, Color color, String label)? _evaluate(String text) {
    if (text.isEmpty) return null;

    if (text.length < 8) {
      return (0.33, AppColor.error, 'Débil');
    }

    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(text);
    final hasNumbers = RegExp(r'\d').hasMatch(text);
    final hasSpecial = RegExp(r'[\W_]').hasMatch(text);

    if (hasLetters && hasNumbers && hasSpecial) {
      return (1.0, AppColor.primary, 'Fuerte');
    }

    return (0.66, AppColor.warning, 'Media');
  }

  Widget _buildContent(BuildContext context, String text) {
    final strength = _evaluate(text);
    if (strength == null) return const SizedBox.shrink();

    final (percent, color, label) = strength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.heightSmall,
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 6,
                  color: context.colorScheme.onSurface.withOpacity(0.12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      widthFactor: percent,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            TextFormat.label(
              label,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeController = controller;
    if (activeController != null) {
      return AnimatedBuilder(
        animation: activeController,
        builder: (context, _) => _buildContent(context, activeController.text),
      );
    }
    return _buildContent(context, password ?? '');
  }
}
