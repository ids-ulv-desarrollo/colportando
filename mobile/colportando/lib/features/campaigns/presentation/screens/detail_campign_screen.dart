import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class DetailCampignScreen extends StatelessWidget {
  const DetailCampignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: 'Campaña',
      actions: [
        ButtonFormat.icon(
          icon: AppIcon.edit,
          onPressed: () {
            Navigator.pushNamed(context, GlobalRoute.editCampign);
          },
        ),
        ButtonFormat.icon(
          icon: AppIcon.delete,
          onPressed: () {
            DialogFormat(
              title: 'Eliminar campaña',
              content: TextFormat.body("Confirma la eliminación de la campaña"),
              onPressed: () {
                SnackBarFormat().show(context, "Campaa eliminada");
                Navigator.pop(context);
              },
            ).show(context);
          },
        ),
      ],
      children: [
        Row(children: [Expanded(child: TextFormat.title('Nombre Campaña'))]),
        ContainerFormat(
          children: [
            TextFormat.subtitle("Estado"),
            AppSpacing.heightMedium,
            TextFormat.body("Periodo"),
            TextFormat.body("Participantes: ###"),
            AppSpacing.heightMedium,
            TextFormat.subtitle("Avance"),
          ],
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Ver grupos",
          icon: AppIcon.grupos,
          onPressed: () => Navigator.pushNamed(context, GlobalRoute.groups),
        ),
        AppSpacing.heightMedium,
        ButtonFormat.secondary(
          label: "Ver participantes",
          icon: AppIcon.participaciones,
          onPressed: () =>
              Navigator.pushNamed(context, GlobalRoute.participants),
        ),
        AppSpacing.heightMedium,
      ],
    );
  }
}
