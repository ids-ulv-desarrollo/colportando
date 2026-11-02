import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla de agenda y eventos de la campaña.
class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Agenda",
      children: [
        TextFormat.subtitle("Eventos y calendario de la campaña"),
      ],
    );
  }
}

