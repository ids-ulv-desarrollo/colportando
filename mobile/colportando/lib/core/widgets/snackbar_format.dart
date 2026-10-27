import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class SnackBarFormat {
  void show(
    final BuildContext context,
    final String message, {
    final bool? isError,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderSmall,
        ),
        behavior: SnackBarBehavior.floating,
        content: TextFormat.bodyWhite(message),
        duration: const Duration(seconds: 1, milliseconds: 500),
        backgroundColor: isError == true ? AppColor.error : AppColor.primary,
      ),
    );
  }
}
