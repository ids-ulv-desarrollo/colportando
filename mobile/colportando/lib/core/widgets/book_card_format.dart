import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class BookCardFormat extends StatelessWidget {
  final String title;
  final String? category;
  final Widget image;
  final Widget? leadingAction;
  final Widget? trailingAction;
  final Widget? titleTrailing;
  final Widget? categoryLeading;
  final Widget? categoryTrailing;
  final String titleLabel;
  final bool showDivider;
  final VoidCallback? onPressed;
  final double imageHeight;
  final CrossAxisAlignment titleCrossAxisAlignment;
  final CrossAxisAlignment categoryCrossAxisAlignment;
  final Axis categoryDirection;
  final MainAxisAlignment categoryAlignment;
  final double categorySpacing;
  final bool leadingActionAtBottom;
  final bool categoryIsSecondary;

  const BookCardFormat({
    super.key,
    required this.title,
    required this.category,
    required this.image,
    this.leadingAction,
    this.trailingAction,
    this.titleTrailing,
    this.categoryLeading,
    this.categoryTrailing,
    this.titleLabel = 'Título',
    this.showDivider = true,
    this.onPressed,
    this.imageHeight = 220,
    this.titleCrossAxisAlignment = CrossAxisAlignment.start,
    this.categoryCrossAxisAlignment = CrossAxisAlignment.start,
    this.categoryDirection = Axis.horizontal,
    this.categoryAlignment = MainAxisAlignment.start,
    this.categorySpacing = 8,
    this.leadingActionAtBottom = false,
    this.categoryIsSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerFormat(
      onPressed: onPressed,
      children: [
        SizedBox(
          height: imageHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(borderRadius: AppSpacing.borderSmall, child: image),
              if (leadingAction != null)
                Positioned(
                  top: leadingActionAtBottom ? null : 0,
                  bottom: leadingActionAtBottom ? 0 : null,
                  left: 0,
                  child: leadingAction!,
                ),
              if (trailingAction != null)
                Positioned(top: 0, right: 0, child: trailingAction!),
            ],
          ),
        ),
        AppSpacing.heightMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: titleCrossAxisAlignment,
          children: [
            TextFormat.bodySecondary(titleLabel),
            if (titleTrailing != null) titleTrailing!,
          ],
        ),
        TextFormat.body(title),
        if (showDivider) ...[
          AppSpacing.heightSmall,
          const Divider(color: AppColor.black, thickness: 2, height: 2),
          AppSpacing.heightSmall,
        ],
        _buildCategoryContent(),
      ],
    );
  }

  Widget _buildCategoryContent() {
    final customItems = [
      if (categoryLeading != null) categoryLeading!,
      if (categoryTrailing != null) categoryTrailing!,
    ];
    final items = customItems.isNotEmpty
        ? customItems
        : category?.trim().isNotEmpty == true
        ? [
            AppIcon.categoria,
            Flexible(
              child: _SingleLineTitle(
                text: category!.trim(),
                isSecondary: categoryIsSecondary,
              ),
            ),
          ]
        : [AppIcon.categoria];

    return Flex(
      direction: categoryDirection,
      mainAxisAlignment: categoryAlignment,
      crossAxisAlignment: categoryCrossAxisAlignment,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0)
            categoryDirection == Axis.horizontal
                ? SizedBox(width: categorySpacing)
                : SizedBox(height: categorySpacing),
          items[index],
        ],
      ],
    );
  }
}

class _SingleLineTitle extends StatelessWidget {
  final String text;
  final bool isSecondary;

  const _SingleLineTitle({
    required this.text,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: isSecondary
          ? Theme.of(context).textTheme.bodyMedium
          : Theme.of(context).textTheme.titleMedium,
    );
  }
}
