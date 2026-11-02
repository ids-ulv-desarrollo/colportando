import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla de solicitudes y recepción de material para colportaje.
class AcquisitionsScreen extends StatelessWidget {
  const AcquisitionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Adquisiciones",
      children: [
        TextFormat.subtitle("Material solicitado"),
      ],
    );
  }
}

