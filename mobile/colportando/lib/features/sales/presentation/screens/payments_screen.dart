import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla de historial de pagos y cobros aplicados.
class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Pagos",
      children: [
        TextFormat.subtitle("Cobros aplicados y pagos recibidos"),
      ],
    );
  }
}

