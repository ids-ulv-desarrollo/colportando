import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla de campo y asignación territorial.
class FieldsScreen extends StatelessWidget {
  const FieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Campos",
      children: [
        TextFormat.subtitle("Zonas y territorios asignados"),
      ],
    );
  }
}

