import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class TabBarFormat extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Color? activeColor;

  const TabBarFormat({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTabSelected,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppSpacing.borderSmall,
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) => _TabItem(
            label: labels[index],
            index: index,
            selectedIndex: selectedIndex,
            onTabSelected: onTabSelected,
            activeColor: activeColor ?? AppColor.secondary,
          ),
        ),
      ),
    );
  }
}

// Widget privado auxiliar para cada botón individual
class _TabItem extends StatelessWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Color activeColor;

  const _TabItem({
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: AppSpacing.borderSmall,
        onTap: () => onTabSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: AppSpacing.paddingSymetric0_8,
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: AppSpacing.borderSmall,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppText.body.copyWith(
              color: isSelected
                  ? AppColor.white
                  : context.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
