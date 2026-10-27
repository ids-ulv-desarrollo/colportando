import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class FilterChipFormat extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const FilterChipFormat({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppSpacing.borderSmall,
      // Al hacer clic, invierte el estado.
      onTap: () => onSelected(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.secondary : context.colorScheme.surface,

          borderRadius: AppSpacing.borderSmall,
        ),
        child: Text(
          label,
          style: AppText.body.copyWith(
            color: isSelected ? AppColor.white : context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
