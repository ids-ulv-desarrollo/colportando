import 'package:colportando/core/theme/app_safe.dart';
import 'package:flutter/material.dart';

// Scaffold base y reutilizable para cualquier pantalla de la app.
class ScaffoldFormat extends StatelessWidget {
  final List<Widget> children;
  final String? titleAppBar;
  final Widget? drawer;
  // Llave global para el formulario.
  final GlobalKey<FormState>? formKey;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Future<void> Function()? onRefresh;
  final bool isScrollable;
  final bool extendBody;

  const ScaffoldFormat({
    super.key,
    this.children = const [],
    this.titleAppBar,
    this.drawer,
    this.formKey,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.onRefresh,
    this.isScrollable = true,
    this.extendBody = false,
  });

  @override
  Widget build(BuildContext context) {
    // Con scroll se usa AppSafe; sin scroll (PageView) cada página aplica su propio AppSafe, ya que si se le aplica scroll no dejará refrescar, sino que aplicará directamente el scroll.
    final Widget content = isScrollable
        ? AppSafe(
            onRefresh: onRefresh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          )
        : SafeArea(
            child: children.isNotEmpty
                ? children.first
                : const SizedBox.shrink(),
          );

    return Scaffold(
      appBar: titleAppBar != null
          ? AppBar(title: Text(titleAppBar!), actions: actions)
          : null,
      drawer: drawer,
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
