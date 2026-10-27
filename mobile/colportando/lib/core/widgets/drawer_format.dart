import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Elemento individual para las opciones del Drawer.
class DrawerItem {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;

  const DrawerItem({required this.icon, required this.label, this.onPressed});
}

// Widget base y reutilizable para el menú lateral (Drawer).
class DrawerFormat extends StatelessWidget {
  // Logo o foto de perfil que se ubica en la cabecera.
  final Widget? logo;
  // Listado de opciones del Drawer.
  final List<DrawerItem> items;
  // Callback opcional si se requiere manejar la acción por índice.
  final ValueChanged<int>? onPressed;
  // Índice del elemento actualmente seleccionado.
  final int? selectedIndex;

  const DrawerFormat({
    super.key,
    this.logo,
    required this.items,
    this.onPressed,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            logo ?? _LogoFormart(),
            const Divider(),
            Expanded(
              child: ListView.separated(
                padding: AppSpacing.paddingSmall,
                itemCount: items.length,
                separatorBuilder: (_, _) => AppSpacing.heightSmall,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = selectedIndex == index;

                  return ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderSmall,
                    ),
                    selected: isSelected,
                    selectedTileColor: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                    leading: item.icon,
                    title: TextFormat.body(item.label),
                    onTap: () {
                      Scaffold.maybeOf(context)?.closeDrawer();
                      item.onPressed?.call();
                      onPressed?.call(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoFormart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingMedium,
      child: Center(
        child: CircleAvatar(
          radius: 36,
          backgroundColor: context.colorScheme.surface,
          child: AppIcon.person,
        ),
      ),
    );
  }
}
