import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla de participantes asignados a la campaña o zona.
class ParticipantsScreen extends StatelessWidget {
  const ParticipantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Participantes",
      children: [
        TextFormat.subtitle("Equipo asignado"),
      ],
    );
  }
}

