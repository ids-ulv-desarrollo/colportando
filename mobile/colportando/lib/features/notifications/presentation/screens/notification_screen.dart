import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Notificaciones",
      children: [
        TextFormat.title("Notificaciones"),
        TextFormat.body("Notificaciones"),
        TextFormat.bodyWhite("Notificaciones"),
        TextFormat.bodySecondary("Notificaciones"),
        TextFormat.label("Notificaciones"),
      ],
    );
  }
}
