import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class DetailPartipantsScreen extends StatefulWidget {
  const DetailPartipantsScreen({super.key});

  @override
  State<DetailPartipantsScreen> createState() => _DetailPartipantsScreenState();
}

class _DetailPartipantsScreenState extends State<DetailPartipantsScreen> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final List<String> _nameDoc = ["Doc 1", "Doc 2"];
    final List<String> _typeDoc = [
      "Carta de recomendación",
      "Certificado de bautizmo",
    ];
    return ScaffoldFormat(
      titleAppBar: 'Participante',
      actions: [
        ButtonFormat.icon(
          icon: AppIcon.edit,
          onPressed: () {
            DialogFormat(
              title: "Editar participación",
              content: DropdownFormat<String>(
                labelText: "Estado",
                hintText: 'Selecciona una opción',
                value: _selectedStatus,
                onChanged: (value) {
                  setState(() => _selectedStatus = value);
                },
                validator: GlobalValidator.validateRequired,
                items: const [
                  DropdownMenuItem(value: 'Aceptado', child: Text('Aceptado')),
                  DropdownMenuItem(
                    value: 'Rechazado',
                    child: Text('Rechazado'),
                  ),
                ],
              ),
              onPressed: () {
                SnackBarFormat().show(context, "Participante eliminado");
                Navigator.pop(context);
              },
            ).show(context);
          },
        ),
        ButtonFormat.icon(
          icon: AppIcon.delete,
          onPressed: () {
            DialogFormat(
              title: 'Eliminar participante',
              content: TextFormat.body(
                "Confirma la eliminación del participante",
              ),
              onPressed: () {
                SnackBarFormat().show(context, "Participante eliminado");
                Navigator.pop(context);
              },
            ).show(context);
          },
        ),
      ],
      children: [
        Row(
          children: [
            Expanded(child: TextFormat.title('Nombre del participante')),
          ],
        ),
        AppSpacing.heightMedium,
        ContainerFormat(
          children: [
            TextFormat.subtitle("Tipo"),
            AppSpacing.heightMedium,
            TextFormat.subtitle("Estado"),
            AppSpacing.heightMedium,
            TextFormat.body("Residencia"),
            AppSpacing.heightSmall,
            TextFormat.body("Email"),
            AppSpacing.heightSmall,
            TextFormat.body("Telefono"),
            AppSpacing.heightMedium,
            TextFormat.subtitle("Documentos"),
            AppSpacing.heightSmall,
            ListViewFormat(
              emptyMessage: "No hay documentos aún",
              itemCount: 0,
              itemBuilder: (context, index) {
                return ContainerListTile(
                  onPressed: () =>
                      Navigator.pushNamed(context, GlobalRoute.participants),
                  title: _nameDoc[index],
                  subtitle: _typeDoc[index],
                  icon: AppIcon.document,
                );
              },
            ),
            AppSpacing.heightMedium,
          ],
        ),
      ],
    );
  }
}
