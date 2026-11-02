import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla de ventas y entregas de libros a clientes.
class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Ventas",
      children: [
        TextFormat.subtitle("Registro de ventas"),
      ],
    );
  }
}

