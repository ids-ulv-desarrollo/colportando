import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Pantalla principal del catálogo de publicaciones y materiales.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Catálogo",
      children: [
        TextFormat.subtitle("Publicaciones disponibles"),
      ],
    );
  }
}

