import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class DropdownFormat<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final String? Function(T?)? validator;
  final bool isExpanded;

  const DropdownFormat({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      dropdownColor: Theme.of(context).popupMenuTheme.color,
      isDense: true,
      borderRadius: AppSpacing.borderSmall,
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      isExpanded: isExpanded,
      icon: AppIcon.arrowDown,
      style: context.textTheme.bodyLarge,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Padding(padding: AppSpacing.paddingMedium, child: prefixIcon)
            : null,
      ),
    );
  }
}
