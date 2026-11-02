import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/theme/app_text.dart';
import 'package:colportando/core/widgets/bottom_bar_format.dart';
import 'package:flutter/material.dart';

// Barra de navegación lateral para tablet, usa los mismos ítems que BottomBarFormat.
class SideBarFormat extends StatelessWidget {
  final ValueChanged<int>? onPressed;
  final int selectedIndex;
  final List<BottomBarItem> items;

  const SideBarFormat({
    super.key,
    this.onPressed,
    this.selectedIndex = 0,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: AppColor.secondary,
      selectedIndex: selectedIndex >= 0 && selectedIndex < items.length
          ? selectedIndex
          : null,
      onDestinationSelected: onPressed,
      labelType: NavigationRailLabelType.all,
      indicatorColor: AppColor.backgroundDark.withOpacity(0.3),
      indicatorShape: const RoundedRectangleBorder(
        borderRadius: AppSpacing.borderMedium,
      ),
      selectedLabelTextStyle: AppText.label.copyWith(color: AppColor.white),
      unselectedLabelTextStyle: AppText.label,
      destinations: [
        for (final item in items)
          NavigationRailDestination(icon: item.icon, label: Text(item.label)),
      ],
    );
  }
}
