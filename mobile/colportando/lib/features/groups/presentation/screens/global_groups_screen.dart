import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class GlobalGroupsScreen extends StatefulWidget {
  const GlobalGroupsScreen({super.key});

  @override
  State<GlobalGroupsScreen> createState() => _GlobalGroupsScreenState();
}

class _GlobalGroupsScreenState extends State<GlobalGroupsScreen> {
  final List<String> names = ["itiel", "moy", "jair"];
  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Grupos",
      children: [
        ContainerFormat(
          children: [
            TextFormat.subtitle("Grupos activos", textAlign: .left),
            Row(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(right: 25.0),
                //   child: Image.network(
                //     "https://cdn-icons-png.flaticon.com/512/3589/3589902.png",
                //     height: 130,
                //   ),
                // ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .center,
                    children: [
                      TextFormat.bodySecondary("Zona asignada 1: 5"),
                      TextFormat.bodySecondary("Zona asignada 2: 6"),
                      TextFormat.bodySecondary("Zona asignada 3: 3"),
                      TextFormat.bodySecondary("Zona asignada 4: 5"),
                      ButtonFormat.primary(
                        label: "Ver grupos",
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormat.subtitle("Apelaciones", textAlign: .center),
        ),
        ListViewFormat(
          itemCount: 3,
          emptyMessage: "No se encontraron resultados.",
          emptyWidget: AppIcon.noAccounts,
          itemBuilder: (context, index) {
            return ContainerListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [TextFormat.bodySecondary("Folio: 1000")],
              ),
              subtitle: names[index],
              subsubtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormat.label("grupo 1"),

                  Container(
                    height: 20,
                    width: 85,
                    decoration: BoxDecoration(
                      color: getColorstats(index).withOpacity(0.3),
                      borderRadius: AppSpacing.borderMedium,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: TextFormat.label(
                        "Rechazado",
                        textAlign: .center,
                        color: getColorstats(index),
                        fontWeight: .w900,
                      ),
                    ),
                  ),
                ],
              ),
              //showTrailing: false,
              icon: AppIcon.apelaciones,
              expandedChild: [TextFormat.label("Chismoso")],
            );
          },
        ),
      ],
    );
  }

  Color getColorstats(int index) {
    return switch (index + 1) {
      == 1 => AppColor.warning,
      == 2 => AppColor.error,
      == 3 => AppColor.primary,
      _ => AppColor.gray,
    };
  }
}
