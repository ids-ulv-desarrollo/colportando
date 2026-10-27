import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Widget base y reutilizable para hojas modales inferiores (Bottom Sheet).
class BottomSheetFormat extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const BottomSheetFormat({
    super.key,
    required this.title,
    required this.children,
  });

  // Muestra el bottom sheet en pantalla y retorna el resultado al cerrarse.
  Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // Evita que el teclado tape el contenido.
        padding: AppSpacing.paddingMedium.add(
          EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormat.subtitle(title),
            AppSpacing.heightMedium,
            ...children,
          ],
        ),
      ),
    );
  }
}
