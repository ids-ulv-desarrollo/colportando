import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_breakpoint.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

// Widget para mantener seguro, con padding fijo y permitir scroll en la pantalla.
class AppSafe extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  final bool isScrollable;

  const AppSafe({
    super.key,
    required this.child,
    this.onRefresh,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    // Limita el ancho del contenido y lo centra en pantallas grandes.
    final constrainedChild = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppBreakpoint.contentMaxWidth,
        ),
        child: child,
      ),
    );

    if (!isScrollable) {
      return SafeArea(
        child: Padding(
          padding: AppSpacing.paddingMedium,
          child: constrainedChild,
        ),
      );
    }

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
            // Se asegura que el contenido no se desborde en pantallas pequeñas.
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - scrollPadding.vertical,
                minWidth: constraints.maxWidth - scrollPadding.horizontal,
              ),
              child: constrainedChild,
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
