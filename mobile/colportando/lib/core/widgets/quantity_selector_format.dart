import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Selector numérico compacto de incremento y decremento.
class QuantitySelectorFormat extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool enabled;

  const QuantitySelectorFormat({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrement = enabled && value > min;
    final canIncrement = enabled && value < max;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppSpacing.borderSmall,
        border: Border.all(
          color: context.colorScheme.onSurface.withOpacity(0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: AppIcon.remove,
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            onPressed: canDecrement ? () => onChanged(value - 1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormat.title("$value"),
          ),
          IconButton(
            icon: AppIcon.add,
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            onPressed: canIncrement ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
