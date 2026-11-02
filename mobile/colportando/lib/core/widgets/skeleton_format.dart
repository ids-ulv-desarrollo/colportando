import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonFormat extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const SkeletonFormat({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      effect: ShimmerEffect(
        baseColor: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.15),
        highlightColor: context.colorScheme.onSurface.withValues(alpha: 0.04),
        duration: const Duration(milliseconds: 1000),
      ),
      child: child,
    );
  }
}
