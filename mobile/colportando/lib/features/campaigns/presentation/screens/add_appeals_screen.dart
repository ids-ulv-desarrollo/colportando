import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/campaigns/presentation/riverpod/appeals_riverpod.dart';
import 'package:colportando/features/groups/presentation/riverpod/groups_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppealFormScreen extends ConsumerStatefulWidget {
  const AppealFormScreen({super.key});

  @override
  ConsumerState<AppealFormScreen> createState() => _AppealFormScreenState();
}

class _AppealFormScreenState extends ConsumerState<AppealFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _reasonController = TextEditingController();
  final _dateController = TextEditingController();
  late final DateTime _realizationDate;
  late final String _folio;
  String? _currentGroup;
  String? _requestedGroup;

  @override
  void initState() {
    super.initState();
    _realizationDate = DateTime.now();
    _folio = "APL-${DateTime.now().microsecondsSinceEpoch}";
    _dateController.text = _formatDate(_realizationDate);
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _reasonController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final groupNames = ref
        .watch(groupsProvider)
        .map((group) => group.name)
        .toSet()
        .toList();
    final requestedGroupNames = groupNames
        .where((groupName) => groupName != _currentGroup)
        .toList();

    return ScaffoldFormat(
      titleAppBar: "Nueva apelación",
      formKey: _formKey,
      children: [
        if (user == null)
          InputTextFormart(
            labelText: "Solicitante",
            hintText: "Escribe tu nombre",
            controller: _userNameController,
            maxLength: 100,
            validator: _requiredField,
          )
        else ...[
          TextFormat.label("Solicitante"),
          AppSpacing.heightSmall,
          TextFormat.body(user.name),
        ],
        AppSpacing.heightMedium,
        DropdownFormat<String>(
          labelText: "Grupo actual",
          hintText: "Selecciona tu grupo actual",
          value: _currentGroup,
          items: [
            for (final groupName in groupNames)
              DropdownMenuItem(value: groupName, child: Text(groupName)),
          ],
          onChanged: (value) => setState(() {
            _currentGroup = value;
            if (_requestedGroup == value) _requestedGroup = null;
          }),
          validator: (value) => value == null
              ? groupNames.isEmpty
                    ? "No hay grupos creados para elegir"
                    : "Selecciona tu grupo actual"
              : null,
        ),
        AppSpacing.heightMedium,
        TextFormField(
          controller: _dateController,
          readOnly: true,
          decoration: const InputDecoration(labelText: "Fecha de realización"),
        ),
        AppSpacing.heightMedium,
        DropdownFormat<String>(
          labelText: "Grupo al que solicitas moverte",
          hintText: "Selecciona el grupo destino",
          value: _requestedGroup,
          items: [
            for (final groupName in requestedGroupNames)
              DropdownMenuItem(value: groupName, child: Text(groupName)),
          ],
          onChanged: (value) => setState(() => _requestedGroup = value),
          validator: (value) => value == null
              ? requestedGroupNames.isEmpty
                    ? "No hay otro grupo disponible"
                    : "Selecciona el grupo destino"
              : null,
        ),
        AppSpacing.heightMedium,
        InputTextFormart(
          labelText: "Motivo",
          hintText: "Explica el motivo de la solicitud",
          controller: _reasonController,
          maxLength: 500,
          maxLines: 4,
          minLines: 3,
          validator: _requiredField,
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Realizar apelación",
          onPressed: () => _confirmAppeal(
            user?.id ?? unauthenticatedAppealUserId,
            user?.name ?? _userNameController.text.trim(),
          ),
        ),
        ButtonFormat.secondary(
          label: "Cancelar",
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  String? _requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Este campo es obligatorio";
    }
    return null;
  }

  Future<void> _confirmAppeal(String userId, String userName) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Confirmar apelación"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormat.label("Folio: $_folio"),
            AppSpacing.heightSmall,
            TextFormat.body(userName),
            AppSpacing.heightMedium,
            TextFormat.body(
              "¿Estás seguro de solicitar el cambio al grupo $_requestedGroup?",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Enviar apelación"),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    _submitAppeal(userId, userName);
  }

  void _submitAppeal(String userId, String userName) {
    ref
        .read(appealsProvider.notifier)
        .createAppeal(
          id: _folio,
          userId: userId,
          userName: userName,
          currentGroup: _currentGroup!,
          realizationDate: _realizationDate,
          requestedGroup: _requestedGroup!,
          reason: _reasonController.text.trim(),
        );

    SnackBarFormat().show(context, "Apelación realizada");
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, "0");
    final month = date.month.toString().padLeft(2, "0");
    return "$day/$month/${date.year}";
  }
}
