import 'package:colportando/core/constants/strings_constants.dart';
import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class ButtonFormat {
  // Botón principal de acción (ElevatedButton).
  static Widget primary({
    required String label,
    required VoidCallback onPressed,
    GlobalKey<FormState>? formKey,
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : () => _formValidate(formKey, onPressed),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            )
          : TextFormat.bodyWhite(label),
    );
  }

  // Botón de texto plano (TextButton).
  static Widget text({
    required String label,
    required VoidCallback onPressed,
    GlobalKey<FormState>? formKey,
    bool isLoading = false,
  }) {
    return Builder(
      builder: (context) {
        return TextButton(
          style: TextButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
          onPressed: isLoading ? null : () => _formValidate(formKey, onPressed),
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                )
              : TextFormat.subtitle(label),
        );
      },
    );
  }

  // Botón circular con icono (IconButton).
  static Widget icon({
    required Widget icon,
    required VoidCallback onPressed,
    bool? isSelected,
  }) {
    return Builder(
      builder: (context) => IconButton(
        onPressed: onPressed,
        icon: icon,
        style: isSelected == true
            ? IconButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: context.colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }

  // Botones de acción para diálogos (Cancelar y Confirmar).
  static Widget dialog({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    GlobalKey<FormState>? formKey,
    bool isLoading = false,
  }) {
    return Builder(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 35,
              child: OutlinedButton(
                onPressed: onCancel ?? () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 35),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TextFormat.bodySecondary(StringsConstants.cancel),
                ),
              ),
            ),
          ),
          AppSpacing.widthSmall,
          Expanded(
            child: SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => _formValidate(formKey, onConfirm),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 35),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(),
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TextFormat.bodyWhite(StringsConstants.confirm),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Valida el formulario si se proporciona un formKey antes de ejecutar la acción.
  static void _formValidate(
    GlobalKey<FormState>? formKey,
    VoidCallback onPressed,
  ) {
    if (formKey == null || (formKey.currentState?.validate() ?? false)) {
      onPressed();
    }
  }
}
