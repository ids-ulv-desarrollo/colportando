import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/skeleton_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class ListViewFormat extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final String? emptyMessage;
  final Widget? emptyWidget;
  final Widget? skeletonItem;
  final int skeletonCount;
  final Axis scrollDirection;
  final double? height;

  const ListViewFormat({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.isLoading = false,
    this.emptyMessage,
    this.emptyWidget,
    this.skeletonItem,
    this.skeletonCount = 3,
    this.scrollDirection = Axis.vertical,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isHorizontal = scrollDirection == Axis.horizontal;

    // Se muestra el skeleton placeholder si la petición está activa y la lista está vacía.
    if (isLoading && itemCount == 0) {
      return SkeletonFormat(
        isLoading: true,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: padding ?? EdgeInsets.zero,
          itemCount: skeletonCount,
          separatorBuilder: (_, _) => AppSpacing.heightMedium,
          itemBuilder: (context, index) => skeletonItem,
        ),
      );
    }

    // Se muestra el estado vacío si no hay elementos.
    if (itemCount == 0 && (emptyMessage != null || emptyWidget != null)) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (emptyWidget != null) ...[
                emptyWidget!,
                AppSpacing.heightMedium,
              ],
              if (emptyMessage != null) TextFormat.bodySecondary(emptyMessage!),
            ],
          ),
        ),
      );
    }

    // Se renderiza la lista con separadores.
    final listView = ListView.separated(
      scrollDirection: scrollDirection,
      shrinkWrap: true,
      physics: isHorizontal
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.zero,
      itemCount: itemCount,
      separatorBuilder: (_, _) =>
          isHorizontal ? AppSpacing.widthMedium : AppSpacing.heightMedium,
      itemBuilder: itemBuilder,
    );

    if (isHorizontal) {
      return SizedBox(height: height ?? 40, child: listView);
    }

    return listView;
  }
}
