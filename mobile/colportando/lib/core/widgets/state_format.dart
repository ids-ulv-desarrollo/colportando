import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class StateFormat extends StatelessWidget {
  final String? code;
  final bool isActive;
  final String activeLabel;
  final String inactiveLabel;
  final Color? activeColor;
  final Color? inactiveColor;

  const StateFormat({
    super.key,
    this.code,
    required this.isActive,
    this.activeLabel = 'Activo',
    this.inactiveLabel = 'Inactivo',
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedActiveColor =
        activeColor ?? Theme.of(context).colorScheme.primary;
    final statusColor = isActive ? resolvedActiveColor : inactiveColor;
    final statusText = isActive ? activeLabel : inactiveLabel;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: [
        if (code != null && code!.trim().isNotEmpty)
          TextFormat.bodySecondary('${code!.trim()} ·'),
        if (isActive) Icon(Icons.circle, size: 8, color: resolvedActiveColor),
        TextFormat.bodySecondary(statusText, color: statusColor),
      ],
    );
  }
}
