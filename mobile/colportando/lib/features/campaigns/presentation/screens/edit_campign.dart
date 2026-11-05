import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/date_picker_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class EditCampignScreen extends StatefulWidget {
  const EditCampignScreen({super.key});

  @override
  State<EditCampignScreen> createState() => _EditCampignScreenState();
}

class _EditCampignScreenState extends State<EditCampignScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStatus;

  Future<void> _selectDate(TextEditingController controller) async {
    final pickedDate = await DatePickerFormat(
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).show(context);

    if (pickedDate != null) {
      final formattedDate =
          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      formKey: _formKey,
      titleAppBar: 'Editar Campaña',
      children: [
        TextFormat.subtitle("Ingresa los nuevos datos de la campaña"),
        AppSpacing.heightMedium,
        TextFormat.body("Nombre de la campaña"),
        AppSpacing.heightMedium,
        const InputTextFormart(
          validator: GlobalValidator.validateRequired,
          labelText: "Nombre",
          hintText: "Ingresa un nuevo nombre",
          maxLength: 30,
        ),
        AppSpacing.heightMedium,
        TextFormat.body('Periodo de la campaña'),
        AppSpacing.heightMedium,
        Row(
          children: [
            Expanded(
              child: InputTextFormart(
                validator: GlobalValidator.validateRequired,
                controller: _startDateController,
                labelText: 'Inicio',
                hintText: 'Ej. 01/06/2026',
                maxLength: 15,
                suffixIcon: ButtonFormat.icon(
                  icon: AppIcon.calendar,
                  onPressed: () => _selectDate(_startDateController),
                ),
              ),
            ),
            AppSpacing.widthMedium,
            Expanded(
              child: InputTextFormart(
                validator: GlobalValidator.validateRequired,
                controller: _endDateController,
                labelText: 'Fin',
                hintText: 'Ej. 01/08/2026',
                maxLength: 15,
                suffixIcon: ButtonFormat.icon(
                  icon: AppIcon.calendar,
                  onPressed: () => _selectDate(_endDateController),
                ),
              ),
            ),
          ],
        ),
        AppSpacing.heightMedium,
        TextFormat.body("Estado de la campaña"),
        AppSpacing.heightMedium,
        DropdownFormat<String>(
          labelText: "Estado",
          hintText: 'Selecciona un estado',
          value: _selectedStatus,
          onChanged: (value) {
            setState(() => _selectedStatus = value);
          },
          validator: GlobalValidator.validateRequired,
          items: const [
            DropdownMenuItem(value: 'Activa', child: Text('Activa')),
            DropdownMenuItem(value: 'Proxima', child: Text('Próxima')),
            DropdownMenuItem(value: 'Finalizada', child: Text('Finalizada')),
          ],
        ),
        TextFormat.bodySecondary("Puedes cerra la campaña"),
        AppSpacing.heightMedium,
        ButtonFormat.dialog(
          formKey: _formKey,
          onConfirm: () {
            DialogFormat(
              title: "¿Estas seguro?",
              content: TextFormat.body("Confirma la edición de la campaña."),
              onPressed: () {
                SnackBarFormat().show(context, "Confirmado");
                Navigator.pop(context);
              },
            ).show(context);
          },
        ),
      ],
    );
  }
}
