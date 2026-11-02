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
  // Callback al presionar el logo/avatar de perfil.
  final VoidCallback? onProfileTap;
  // Listado de opciones del Drawer.
  final List<DrawerItem> items;
  // Callback opcional si se requiere manejar la acción por índice.
  final ValueChanged<int>? onPressed;
  // Índice del elemento actualmente seleccionado.
  final int? selectedIndex;

  const DrawerFormat({
    super.key,
    this.logo,
    this.onProfileTap,
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
            logo ?? _LogoFormart(onTap: onProfileTap),
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
                    selectedTileColor: context.colorScheme.surface,
                    selectedColor: context.colorScheme.onSurface,
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
  final VoidCallback? onTap;

  const _LogoFormart({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingMedium,
      child: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(36),
          onTap: () {
            Scaffold.maybeOf(context)?.closeDrawer();
            onTap?.call();
          },
          child: CircleAvatar(
            radius: 36,
            backgroundColor: context.colorScheme.surface,
            foregroundColor: context.colorScheme.onSurface,
            child: AppIcon.person,
          ),
        ),
      ),
    );
  }
}
