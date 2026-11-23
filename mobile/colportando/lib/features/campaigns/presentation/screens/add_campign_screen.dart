import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_format_date.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/date_picker_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/campaigns/presentation/riverpod/campaign_riverpod.dart';
import 'package:colportando/features/workspace/presentation/riverpod/workspace_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCampignScreen extends ConsumerStatefulWidget {
  const AddCampignScreen({super.key});

  @override
  ConsumerState<AddCampignScreen> createState() => _AddCampignScreenState();
}

class _AddCampignScreenState extends ConsumerState<AddCampignScreen> {
  final TextEditingController _cpNameController = TextEditingController();
  final TextEditingController _cpStartsOnController = TextEditingController();
  final TextEditingController _cpEndsOnController = TextEditingController();
  final TextEditingController _cpDescController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cpNameController.dispose();
    _cpStartsOnController.dispose();
    _cpEndsOnController.dispose();
    _cpDescController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateCampaign() async {
    final club = ref.read(workspaceProvider).workspace?.clubs.firstOrNull;
    if (club == null || club.clubId.isEmpty) {
      SnackBarFormat().show(
        context,
        "No se encontró un club asignado para esta cuenta.",
        isError: true,
      );
      return;
    }

    final startsOn = GlobalFormatDate.toApiFromString(
      _cpStartsOnController.text,
    );
    final endsOn = GlobalFormatDate.toApiFromString(_cpEndsOnController.text);

    if (!GlobalFormatDate.isValidRange(start: startsOn, end: endsOn)) {
      SnackBarFormat().show(
        context,
        "La fecha de fin debe ser posterior a la fecha de inicio.",
        isError: true,
      );
      return;
    }

    final data = await ref
        .read(campaignProvider.notifier)
        .createCampaign(
          clubId: club.clubId,
          name: _cpNameController.text.trim(),
          startsOn: startsOn,
          endsOn: endsOn,
          description: _cpDescController.text.trim().isNotEmpty
              ? _cpDescController.text.trim()
              : null,
        );

    if (mounted && data != null) {
      SnackBarFormat().show(context, "Campaña creada exitosamente");
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final pickedDate = await DatePickerFormat(
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).show(context);

    if (pickedDate != null) {
      controller.text = GlobalFormatDate.toView(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CampaignState>(campaignProvider, (previous, next) {
      if (next.errorMessage != null) {
        SnackBarFormat().show(context, next.errorMessage!, isError: true);
      }
    });

    final campaignState = ref.watch(campaignProvider);
    final workspaceState = ref.watch(workspaceProvider);
    final currentClub = workspaceState.workspace?.clubs.firstOrNull;

    return ScaffoldFormat(
      titleAppBar: 'Crear Campaña',
      formKey: _formKey,
      children: [
        TextFormat.body("Datos de la nueva campaña"),
        AppSpacing.heightSmall,
        TextFormat.subtitle(
          "Club: ${currentClub?.clubName ?? 'Sin club asignado'}",
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          validator: GlobalValidator.validateRequired,
          controller: _cpNameController,
          prefixIcon: AppIcon.campana,
          labelText: "Nombre de la campaña",
          hintText: "Ej. Campaña Verano 2026",
          maxLength: 180,
        ),
        AppSpacing.heightMedium,
        TextFormat.body("Periodo de la campaña"),
        AppSpacing.heightSmall,
        Row(
          children: [
            Expanded(
              child: InputTextFormart(
                validator: GlobalValidator.validateRequired,
                controller: _cpStartsOnController,
                labelText: 'Inicio',
                hintText: 'Ej. 01/06/2026',
                maxLength: 15,
                suffixIcon: ButtonFormat.icon(
                  icon: AppIcon.calendar,
                  onPressed: () => _selectDate(_cpStartsOnController),
                ),
              ),
            ),
            AppSpacing.widthMedium,
            Expanded(
              child: InputTextFormart(
                validator: GlobalValidator.validateRequired,
                controller: _cpEndsOnController,
                labelText: 'Fin',
                hintText: 'Ej. 01/08/2026',
                maxLength: 15,
                suffixIcon: ButtonFormat.icon(
                  icon: AppIcon.calendar,
                  onPressed: () => _selectDate(_cpEndsOnController),
                ),
              ),
            ),
          ],
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _cpDescController,
          prefixIcon: AppIcon.edit,
          labelText: "Descripción",
          hintText: "Descripción de la campaña",
          maxLength: 200,
        ),
        AppSpacing.heightMedium,
        ButtonFormat.secondary(
          label: "Crear Campaña",
          formKey: _formKey,
          isLoading: campaignState.isLoading,
          onPressed: _handleCreateCampaign,
        ),
      ],
    );
  }
}
