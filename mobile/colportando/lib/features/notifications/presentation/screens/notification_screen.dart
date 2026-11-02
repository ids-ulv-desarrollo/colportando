import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:flutter/material.dart';

// Pantalla de notificaciones con diseño de cuadrícula responsiva.
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldFormat(
      titleAppBar: "Notificaciones",
      isResponsive: true,
      children: [
        ContainerListTile(
          icon: AppIcon.notifications,
          title: "Nueva actualización",
          subtitle: "Se ha actualizado la lista de libros y materiales.",
        ),
        ContainerListTile(
          icon: AppIcon.depositos,
          title: "Depósito confirmado",
          subtitle: "Tu depósito reciente ha sido verificado con éxito.",
        ),
        ContainerListTile(
          icon: AppIcon.capacitaciones,
          title: "Próxima capacitación",
          subtitle: "Taller virtual este sábado a las 9:00 AM.",
        ),
        ContainerListTile(
          icon: AppIcon.apelaciones,
          title: "Estado de apelación",
          subtitle: "Tu solicitud se encuentra en proceso de revisión.",
        ),
      ],
    );
  }
}
