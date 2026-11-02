import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla formativa de capacitaciones y "Mi Camino ULV".
class TrainingsScreen extends StatelessWidget {
  const TrainingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Capacitaciones",
      children: [
        TextFormat.subtitle("Mi Camino ULV"),
      ],
    );
  }
}

