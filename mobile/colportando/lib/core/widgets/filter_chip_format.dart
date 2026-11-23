import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class FilterChipFormat extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool)? onSelected;
  final Widget? icon;

  const FilterChipFormat({
    super.key,
    required this.label,
    required this.isSelected,
    this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.secondary : context.colorScheme.surface,

        borderRadius: AppSpacing.borderSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            if (label.isNotEmpty) AppSpacing.widthSmall,
          ],
          if (label.isNotEmpty)
            Text(
              label,
              style: AppText.body.copyWith(
                color: isSelected
                    ? AppColor.white
                    : context.colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );

    if (onSelected == null) return chip;
    return InkWell(
      borderRadius: AppSpacing.borderSmall,
      onTap: () => onSelected!(!isSelected),
      child: chip,
    );
  }
}
