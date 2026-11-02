import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla de participación activa e historial en campañas.
class ParticipationsScreen extends StatelessWidget {
  const ParticipationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Mi Participación",
      children: [
        TextFormat.subtitle("Estado de participación y campaña activa"),
      ],
    );
  }
}

