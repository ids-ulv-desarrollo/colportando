import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Widget base y reutilizable para escanear códigos QR con la cámara.
class QrScannerFormat extends StatelessWidget {
  final String title;
  final String label;

  const QrScannerFormat({super.key, required this.title, required this.label});

  // Abre el escáner en pantalla completa y retorna el código leído (null si se cancela).
  Future<String?> show(BuildContext context) {
    return Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: this,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Ocupa todo el espacio aunque la cámara aún no esté lista (permisos).
      fit: StackFit.expand,
      children: [
        MobileScanner(
          onDetect: (capture) {
            final code = capture.barcodes.firstOrNull?.rawValue;
            // Evita cerrar dos veces si se detecta más de un código seguidos.
            if (code == null || !(ModalRoute.of(context)?.isCurrent ?? false)) {
              return;
            }
            Navigator.pop(context, code);
          },
        ),
        // Marco de enfoque central.
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.secondary, width: 3),
              borderRadius: AppSpacing.borderMedium,
            ),
          ),
        ),
        // Instrucción superior.
        Positioned(
          top: 24,
          left: 16,
          right: 16,
          child: Container(
            padding: AppSpacing.paddingMedium,
            decoration: BoxDecoration(
              color: context.colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: AppSpacing.borderSmall,
            ),
            child: TextFormat.bodySecondary(label, alignCenter: true),
          ),
        ),
      ],
    );
  }
}
