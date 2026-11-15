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

class AddParticipantsScreen extends StatefulWidget {
  const AddParticipantsScreen({super.key});

  @override
  State<AddParticipantsScreen> createState() => _AddParticipantsScreenState();
}

class _AddParticipantsScreenState extends State<AddParticipantsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStatus;

  TextEditingController? get _nameController => null;

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: 'Registrar participante',
      formKey: _formKey,
      children: [
        TextFormat.subtitle("Ingresa los datos de la persona"),
        AppSpacing.heightMedium,
        TextFormat.body("Datos personales"),
        AppSpacing.heightMedium,
        InputTextFormart(
          prefixIcon: AppIcon.person,
          validator: GlobalValidator.validateRequired,
          controller: _nameController,
          labelText: "Nombre",
          hintText: "Nombre completo",
          maxLength: 50,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          prefixIcon: AppIcon.email,
          validator: GlobalValidator.validateEmail,
          controller: _emailController,
          labelText: "Email",
          hintText: "ejemplo@correo.com",
          maxLength: 50,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          prefixIcon: AppIcon.phone,
          validator: GlobalValidator.validateNumber,
          controller: _numberController,
          keyboardType: TextInputType.number,
          labelText: "Número telefonico",
          hintText: "0801040120",
          maxLength: 10,
        ),
        AppSpacing.heightMedium,
        DropdownFormat<String>(
          labelText: "Rol",
          hintText: 'Selecciona una opción',
          value: _selectedStatus,
          onChanged: (value) {
            setState(() => _selectedStatus = value);
          },
          validator: GlobalValidator.validateRequired,
          items: const [
            DropdownMenuItem(
              value: 'Prinicipiante',
              child: Text('Prinicipiante'),
            ),
            DropdownMenuItem(value: 'Colportor', child: Text('Colportor')),
            DropdownMenuItem(value: 'Asociado', child: Text('Asociado')),
          ],
        ),
        AppSpacing.heightMedium,
        DropdownFormat<String>(
          labelText: "Residencia",
          hintText: 'Selecciona una opción',
          value: _selectedStatus,
          onChanged: (value) {
            setState(() => _selectedStatus = value);
          },
          validator: GlobalValidator.validateRequired,
          items: const [
            DropdownMenuItem(value: 'Interno', child: Text('Interno')),
            DropdownMenuItem(value: 'Externo', child: Text('Externo')),
          ],
        ),
        AppSpacing.heightMedium,
        ButtonFormat.dialog(
          formKey: _formKey,
          onConfirm: () {
            DialogFormat(
              title: 'Confirmar registro',
              content: TextFormat.body("Confirma el registro del participante"),
              onPressed: () {
                SnackBarFormat().show(context, "Particpante registrado");
                Navigator.pop(context);
              },
            ).show(context);
          },
        ),
      ],
    );
  }
}
