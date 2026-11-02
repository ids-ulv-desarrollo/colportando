import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/icon_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Tarjeta para listas con soporte opcional de contenido desplegable.
class ContainerListTile extends StatefulWidget {
  final Function()? onPressed;
  final dynamic title;
  final Widget? icon;
  final Widget? leading;
  final String? subtitle;
  final dynamic subsubtitle;
  final Widget? trailing;
  final bool showTrailing;
  final Color? color;
  final List<Widget> expandedChild;

  const ContainerListTile({
    super.key,
    this.onPressed,
    required this.title,
    this.icon,
    this.leading,
    this.subtitle,
    this.subsubtitle,
    this.trailing,
    this.showTrailing = true,
    this.color,
    this.expandedChild = const [],
  });

  @override
  State<ContainerListTile> createState() => _ContainerListTileState();
}

class _ContainerListTileState extends State<ContainerListTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasExpanded = widget.expandedChild.isNotEmpty;

    return ContainerFormat(
      onPressed: hasExpanded
          ? () => setState(() => _isExpanded = !_isExpanded)
          : widget.onPressed,
      children: [
        ListTile(
          leading:
              widget.leading ??
              (widget.icon != null
                  ? IconFormat(icon: widget.icon!, color: widget.color)
                  : null),
          title: widget.title is Widget
              ? widget.title
              : TextFormat.subtitle(widget.title),
          subtitle: widget.subsubtitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.subtitle != null) ...[
                      TextFormat.body(widget.subtitle!),
                    ],
                    widget.subsubtitle is String
                        ? TextFormat.label(widget.subsubtitle)
                        : widget.subsubtitle,
                  ],
                )
              : widget.subtitle != null
              ? TextFormat.bodySecondary(widget.subtitle!)
              : null,
          contentPadding: AppSpacing.paddingSymetric8_0,
          trailing: widget.showTrailing
              ? (widget.trailing ??
                    (hasExpanded
                        ? (_isExpanded ? AppIcon.arrowUp : AppIcon.arrowDown)
                        : AppIcon.arrowRight))
              : null,
        ),
        if (_isExpanded) ...widget.expandedChild,
      ],
    );
  }
}
