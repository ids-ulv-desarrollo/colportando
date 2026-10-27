import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class MenuItemModel {
  final String value;
  final Widget? icon;
  final String text;
  final String? textStyle;

  MenuItemModel({
    required this.value,
    this.icon,
    required this.text,
    this.textStyle,
  });
}

class MenuButtonFormat extends StatelessWidget {
  final List<MenuItemModel> items;
  final ValueChanged<String> onSelected;
  final Widget? child;

  const MenuButtonFormat({
    super.key,
    required this.items,
    required this.onSelected,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0.1, 0),
      borderRadius: AppSpacing.borderSmall,
      onSelected: onSelected,
      icon: child != null ? null : AppIcon.moreHoriz,
      child: child,
      itemBuilder: (BuildContext context) {
        return items.map(
          (item) {
            return PopupMenuItem<String>(
              value: item.value,
              child: Row(
                children: [
                  if (item.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      child: item.icon!,
                    ),
                    AppSpacing.widthSmall,
                  ],
                  TextFormat.body(item.text),
                ],
              ),
            );
          },
        ).toList(); //Se debe retornar la lista de las opciones que trae el menú.
      },
    );
  }
}
