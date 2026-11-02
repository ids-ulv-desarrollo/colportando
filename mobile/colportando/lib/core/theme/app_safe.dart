import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_breakpoint.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

// Widget para mantener seguro, con padding fijo y permitir scroll en la pantalla.
class AppSafe extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  final double? maxWidth;

  const AppSafe({
    super.key,
    required this.child,
    this.onRefresh,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    // El padding va dentro del scroll para que el contenido pase por detrás de la barra inferior flotante y no se recorte antes de llegar a ella.
    final padding = AppSpacing.paddingMedium.resolve(TextDirection.ltr);
    final scrollPadding = padding.copyWith(
      bottom: padding.bottom + MediaQuery.paddingOf(context).bottom,
    );

    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scrollContent = SingleChildScrollView(
            padding: scrollPadding,
            // Permitirá deslizar o refrescar siempre.
            physics: const AlwaysScrollableScrollPhysics(),
            // Limita el ancho en pantallas grandes y asegura el alto mínimo para alinear verticalmente.
            child: Align(
              alignment: .topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - scrollPadding.vertical,
                  maxWidth: maxWidth ?? AppBreakpoint.contentMaxWidth,
                ),
                child: child,
              ),
            ),
          );

          return onRefresh != null
              ? RefreshIndicator(
                  color: context.colorScheme.onSurface,
                  onRefresh: onRefresh!,
                  child: scrollContent,
                )
              : scrollContent;
        },
      ),
    );
  }
}
