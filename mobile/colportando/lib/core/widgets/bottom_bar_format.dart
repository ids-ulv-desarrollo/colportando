import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Elemento individual para la barra de navegación inferior.
class BottomBarItem {
  final Widget icon;
  final Widget? selectedIcon;
  final String label;

  const BottomBarItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
  });
}

// Barra de navegación inferior flotante tipo cápsula.
class BottomBarFormat extends StatelessWidget {
  final ValueChanged<int>? onPressed;
  final int selectedIndex;
  final List<BottomBarItem> items;

  const BottomBarFormat({
    super.key,
    this.onPressed,
    this.selectedIndex = 0,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
        height: MediaQuery.textScalerOf(context).scale(60),
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarTheme.color,
          borderRadius: AppSpacing.borderMedium,
        ),
        child: Row(
          children: [
            for (int i = 0; i < items.length; i++)
              Expanded(
                child: _TabItem(
                  index: i,
                  item: items[i],
                  isSelected: selectedIndex == i,
                  onPressed: onPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Widget interno para cada pestaña.
class _TabItem extends StatelessWidget {
  final int index;
  final BottomBarItem item;
  final bool isSelected;
  final ValueChanged<int>? onPressed;

  const _TabItem({
    required this.index,
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppSpacing.borderMedium,
      onTap: () {
        if (!isSelected && onPressed != null) {
          onPressed!(index);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
          TextFormat.label(
            item.label,
            color: isSelected ? AppColor.white : AppColor.gray,
          ),
        ],
      ),
    );
  }
}
