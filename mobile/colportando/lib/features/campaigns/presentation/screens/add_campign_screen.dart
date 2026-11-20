import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/date_picker_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/campaigns/presentation/riverpod/campaign_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class AddCampignScreen extends ConsumerStatefulWidget {
  const AddCampignScreen({super.key});

  @override
  ConsumerState<AddCampignScreen> createState() => _AddCampignScreenState();
}

class _AddCampignScreenState extends ConsumerState<AddCampignScreen> {
  final TextEditingController _clubIdController = TextEditingController(text: "E0CBA2E7-B5C2-4A43-A2EC-CBD22356FEA5");
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _startsOn;
  DateTime? _endsOn;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _campaign() => ref
      .read(campaignsProvider.notifier)
      .createCampaign(
        clubId: _clubIdController.text.trim(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        startsOn: _startsOn!,
        endsOn: _endsOn!,
      );

  Future<void> _selectDate({
    required TextEditingController controller,
    required bool isStart,
  }) async {
    final pickedDate = await DatePickerFormat(
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).show(context);

    if (pickedDate != null) {
      final formattedDate =
          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      setState(() {
        controller.text = formattedDate;
        if (isStart) {
          _startsOn = pickedDate;
        } else {
          _endsOn = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: 'Crear Campaña',
      formKey: _formKey,
      children: [
        TextFormat.subtitle("Ingresa los datos de la nueva campaña"),
        AppSpacing.heightMedium,
        TextFormat.body("Nombre de la campaña"),
        AppSpacing.heightMedium,
        InputTextFormart(
          validator: GlobalValidator.validateRequired,
          controller: _nameController,
          labelText: "Nombre",
          hintText: "Ingresa un nombre",
          maxLength: 50,
        ),
        AppSpacing.heightMedium,
        TextFormat.body("Descripción"),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _descriptionController,
          labelText: "Descripción (opcional)",
          hintText: "Ingresa una descripción",
          maxLength: 150,
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
                  onPressed: () => _selectDate(
                    controller: _startDateController,
                    isStart: true,
                  ),
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
                  onPressed: () => _selectDate(
                    controller: _endDateController,
                    isStart: false,
                  ),
                ),
              ),
            ),
          ],
        ),
        AppSpacing.heightMedium,
        ButtonFormat.dialog(
          formKey: _formKey,
          onConfirm: () {
            DialogFormat(
              title: 'Confirmar campaña',
              content: TextFormat.body("Confirma la creación de la campaña"),
              onPressed: () {
                SnackBarFormat().show(context, "Campaña creada");
                Navigator.pop(context);
              },
            ).show(context);
          },
        ),
      ],
    );
  }
}
