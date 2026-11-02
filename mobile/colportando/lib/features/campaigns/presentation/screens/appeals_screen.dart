import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla de apelaciones y revisiones de solicitudes.
class AppealsScreen extends StatelessWidget {
  const AppealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Apelaciones",
      children: [
        TextFormat.subtitle("Solicitudes y apelaciones en curso"),
      ],
    );
  }
}

