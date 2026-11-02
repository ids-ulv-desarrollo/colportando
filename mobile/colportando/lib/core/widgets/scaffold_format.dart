import 'package:colportando/core/theme/app_breakpoint.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_safe.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/responsive_grid.dart';
import 'package:flutter/material.dart';

// Scaffold base y reutilizable para cualquier pantalla de la app.
class ScaffoldFormat extends StatelessWidget {
  final List<Widget> children;
  final String? titleAppBar;
  final Widget? leading;
  // Llave global para el formulario.
  final GlobalKey<FormState>? formKey;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Future<void> Function()? onRefresh;
  final bool extendBody;
  // Activa la cuadrícula responsiva (ResponsiveGrid) para distribuir los elementos.
  final bool isResponsive;
  final bool isLoading;
  final Widget? skeletonItem;
  final int? skeletonCount;
  final MainAxisAlignment? mainAxisAlignment;

  const ScaffoldFormat({
    super.key,
    this.children = const [],
    this.titleAppBar,
    this.leading,
    this.formKey,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.onRefresh,
    this.extendBody = false,
    this.isResponsive = false,
    this.isLoading = false,
    this.skeletonItem,
    this.skeletonCount,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    // Determina el contenido principal según si es cuadrícula responsiva o lista vertical estándar.
    final Widget mainContent = (isResponsive && children.isNotEmpty)
        ? ResponsiveGrid(
            items: children,
            isLoading: isLoading,
            skeletonItem: skeletonItem,
            skeletonCount: skeletonCount,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            children: children,
          );

    // Ancho máximo: expande a desktopMaxWidth en escritorio o vista responsiva.
    final double effectiveMaxWidth =
        (AppBreakpoint.isDesktop(context) || isResponsive)
        ? AppBreakpoint.desktopMaxWidth
        : AppBreakpoint.contentMaxWidth;

    // Aplica SafeArea, padding estándar y scroll mediante AppSafe.
    final Widget content = AppSafe(
      onRefresh: onRefresh,
      maxWidth: effectiveMaxWidth,
      child: mainContent,
    );

    // Muestra el botón de menú si el Scaffold padre (ej. MainNavigationScreen) tiene Drawer.
    final hasAncestorDrawer = Scaffold.maybeOf(context)?.hasDrawer ?? false;
    final effectiveLeading =
        leading ??
        (hasAncestorDrawer
            ? Padding(
                padding: AppSpacing.paddingSmall,
                child: ButtonFormat.icon(
                  icon: AppIcon.menu,
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null);

    final hasAppBar =
        titleAppBar != null || effectiveLeading != null || actions != null;

    return Scaffold(
      appBar: hasAppBar
          ? AppBar(
              backgroundColor: titleAppBar == null ? Colors.transparent : null,
              title: titleAppBar != null ? Text(titleAppBar!) : null,
              actions: actions,
              leading: effectiveLeading,
            )
          : null,
      body: formKey != null ? Form(key: formKey, child: content) : content,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      // Extiende el cuerpo para que el contenido se muestre detrás de la barra de navegación si se requiere.
      extendBody: extendBody,
      // Barra de navegación inferior para navegar entre páginas.
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
