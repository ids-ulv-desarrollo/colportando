import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Widget reutilizable para generar y presentar códigos QR de asistencia.
class QrGeneratorFormat extends StatelessWidget {
  final String data;
  final double size;
  final String title;
  final String subtitle;

  const QrGeneratorFormat({
    super.key,
    required this.data,
    this.size = 240,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormat.subtitle(title),
        AppSpacing.heightSmall,

        TextFormat.bodySecondary(subtitle),
        AppSpacing.heightMedium,
        // Contenedor blanco de alto contraste.
        Container(
          padding: AppSpacing.paddingMedium,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: AppSpacing.borderMedium,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: size,
            backgroundColor: AppColor.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColor.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColor.black,
            ),
          ),
        ),
      ],
    );
  }
}
