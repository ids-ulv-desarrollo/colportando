import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitConfirmationFormat extends StatefulWidget {
  final Widget child;

  const ExitConfirmationFormat({super.key, required this.child});

  @override
  State<ExitConfirmationFormat> createState() => _ExitConfirmationFormatState();
}

class _ExitConfirmationFormatState extends State<ExitConfirmationFormat> {
  static const _channel = MethodChannel('colportando/app');
  DateTime? _lastPressedAt;

  // Envía el evento al canal para mover la app a segundo plano, y si falla, cierra la app.
  Future<void> _moveToBackground() async {
    try {
      await _channel.invokeMethod('moveToBackground');
    } catch (_) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          SnackBarFormat().show(context, "Presiona nuevamente para salir");
        } else {
          _moveToBackground();
        }
      },
      child: widget.child,
    );
  }
}
