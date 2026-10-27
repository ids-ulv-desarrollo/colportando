import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class BadgeFormat extends StatelessWidget {
  final int unreadCount;
  const BadgeFormat({super.key, required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ButtonFormat.icon(
          icon: AppIcon.notifications,
          onPressed: () =>
              Navigator.pushNamed(context, GlobalRoute.notifications),
        ),
        if (unreadCount > 0)
          Positioned(
            top: 6,
            right: 6,
            // Se ignora el click del punto rojo para que el click sea en el botón.
            child: IgnorePointer(
              // Contador de notificaciones.
              child: Container(
                width: 20,
                height: 20,
                // El borde simula un espacio invisible alrededor del punto rojo.
                decoration: BoxDecoration(
                  color: AppColor.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                // El FittedBox asegura que el texto se escale sin alterar el tamaño del contenedor.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: TextFormat.bodyWhite(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
