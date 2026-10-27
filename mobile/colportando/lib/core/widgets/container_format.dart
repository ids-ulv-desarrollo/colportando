import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ContainerFormat extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onPressed;
  final Color? color;
  final double? width;

  const ContainerFormat({
    super.key,
    required this.children,
    this.onPressed,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: color ?? context.colorScheme.surface,
        borderRadius: AppSpacing.borderSmall,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.onSurface.withOpacity(0.2),
            blurRadius: 0.5,
            offset: const Offset(0, 0.1),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: AppSpacing.borderSmall,
        onTap: onPressed,
        child: Padding(
          padding: AppSpacing.paddingSmall,
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }
}
