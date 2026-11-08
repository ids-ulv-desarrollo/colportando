import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class EditParticipantsScreen extends StatefulWidget {
  const EditParticipantsScreen({super.key});

  @override
  State<EditParticipantsScreen> createState() => _EditParticipantsScreenState();
}

class _EditParticipantsScreenState extends State<EditParticipantsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      formKey: _formKey,
      titleAppBar: "Editar participante",
      children: [
        TextFormat.subtitle("Ingresa los nuevos datos del participante"),
        AppSpacing.heightMedium,
        TextFormat.body("Correo electrónico"),
        AppSpacing.heightMedium,
        InputTextFormart(
          prefixIcon: AppIcon.email,
          //validator: GlobalValidator.validateEmail,
          controller: _emailController,
          labelText: "Email",
          hintText: "ejemplo@correo.com",
          maxLength: 50,
        ),
        AppSpacing.heightMedium,
        TextFormat.body("Número telefonico"),
        AppSpacing.heightMedium,
        InputTextFormart(
          prefixIcon: AppIcon.phone,
          //validator: GlobalValidator.validateNumber,
          controller: _numberController,
          keyboardType: TextInputType.number,
          labelText: "Número telefonico",
          hintText: "0801040120",
          maxLength: 10,
        ),
        AppSpacing.heightMedium,
        TextFormat.body("Estado del participante"),
        AppSpacing.heightMedium,
        DropdownFormat<String>(
          validator: GlobalValidator.validateRequired,
          labelText: "Estado",
          hintText: 'Selecciona un estado',
          value: _selectedStatus,
          onChanged: (value) {
            setState(() => _selectedStatus = value);
          },
          //validator: GlobalValidator.validateRequired,
          items: const [
            DropdownMenuItem(value: 'Aceptado', child: Text('Aceptado')),
            DropdownMenuItem(value: 'Rechazado', child: Text('Rechazado')),
          ],
        ),
        AppSpacing.heightMedium,
        ButtonFormat.dialog(
          formKey: _formKey,
          onConfirm: () {
            DialogFormat(
              title: "¿Estas seguro?",
              content: TextFormat.body(
                "Confirma la modificación del participante.",
              ),
              onPressed: () {
                SnackBarFormat().show(
                  context,
                  "Participación modificada exitosamente",
                );
                Navigator.pop(context);
              },
            ).show(context);
          },
        ),
      ],
    );
  }
}
