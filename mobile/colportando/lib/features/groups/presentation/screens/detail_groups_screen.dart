import 'dart:io';

import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/file_upload_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/groups/domain/entities/colportor_group.dart';
import 'package:colportando/features/groups/presentation/riverpod/groups_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailGroupsScreen extends ConsumerStatefulWidget {
  final String groupId;

  const DetailGroupsScreen({super.key, required this.groupId});

  @override
  ConsumerState<DetailGroupsScreen> createState() => _DetailGroupsScreenState();
}

class _DetailGroupsScreenState extends ConsumerState<DetailGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    final group = ref
        .watch(groupsProvider)
        .where((group) => group.id == widget.groupId)
        .firstOrNull;

    return ScaffoldFormat(
      titleAppBar: "Detalle del grupo",
      children: [
        if (group == null)
          TextFormat.bodySecondary("Este grupo ya no está disponible.")
        else ...[
          _GroupImage(path: group.imagePath),
          AppSpacing.heightSmall,
          TextFormat.title(group.name),
          AppSpacing.heightSmall,
          TextFormat.bodySecondary("Zona asignada: ${group.assignedZone}"),
          AppSpacing.heightMedium,
          TextFormat.subtitle("Descripción"),
          AppSpacing.heightSmall,
          TextFormat.bodySecondary(
            group.description.isEmpty ? "Sin descripción" : group.description,
          ),
          AppSpacing.heightSmall,
          ButtonFormat.secondary(
            label: "Editar grupo",
            onPressed: () => _editGroup(group),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: ButtonFormat.primary(
                    icon: AppIcon.person,
                    label: "Agregar colportor",

                    onPressed: () => _addColporter(group.id),
                  ),
                ),
                if (group.associate == null) ...[
                  AppSpacing.widthSmall,
                  Expanded(
                    child: ButtonFormat.secondary(
                      label: "Agregar asociado",
                      icon: AppIcon.asociados,
                      onPressed: () => _addAssociate(group.id),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (group.associate != null) ...[
            AppSpacing.heightSmall,
            TextFormat.subtitle("Asociado"),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: TextFormat.bodySecondary(group.associate!),
              trailing: IconButton(
                tooltip: "Eliminar asociado",
                icon: AppIcon.delete,
                onPressed: () => _confirmRemoveMember(
                  memberType: "asociado",
                  name: group.associate!,
                  onConfirm: () => _removeAssociate(group.id),
                ),
              ),
            ),
          ],
          AppSpacing.heightMedium,
          TextFormat.subtitle("Colportores"),
          AppSpacing.heightSmall,
          if (group.colporters.isEmpty)
            TextFormat.bodySecondary("Sin colportores asignados.")
          else
            for (final colporter in group.colporters)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: TextFormat.bodySecondary(colporter),
                trailing: IconButton(
                  tooltip: "Eliminar colportor",
                  icon: AppIcon.delete,
                  onPressed: () => _confirmRemoveMember(
                    memberType: "colportor",
                    name: colporter,
                    onConfirm: () => _removeColporter(group.id, colporter),
                  ),
                ),
              ),
        ],
      ],
    );
  }

  Future<String?> _askForValue({
    required String title,
    required String label,
    String initialValue = "",
    int maxLines = 1,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => _TextPromptDialog(
        title: title,
        label: label,
        initialValue: initialValue,
        maxLines: maxLines,
      ),
    ).then((value) => value?.trim());
  }

  void _editGroup(ColportorGroup group) {
    BottomSheetFormat.content(
      _EditGroupForm(
        group: group,
        onDelete: () => _confirmDeleteGroup(group.id, group.name),
      ),
      title: "Editar grupo",
    ).show(context);
  }

  Future<void> _addColporter(String groupId) async {
    final name = await _askForValue(
      title: "Agregar colportor",
      label: "Nombre del colportor",
    );
    if (name == null || !mounted) return;

    final added = ref
        .read(groupsProvider.notifier)
        .addColporter(groupId: groupId, name: name);
    if (!added) {
      SnackBarFormat().show(
        context,
        "Escribe un nombre nuevo para el colportor.",
        isError: true,
      );
    }
  }

  Future<void> _addAssociate(String groupId) async {
    final name = await _askForValue(
      title: "Agregar asociado",
      label: "Nombre del asociado",
    );
    if (name == null || !mounted) return;

    final added = ref
        .read(groupsProvider.notifier)
        .addAssociate(groupId: groupId, name: name);
    if (!added) {
      SnackBarFormat().show(
        context,
        "El grupo ya tiene un asociado o el nombre está vacío.",
        isError: true,
      );
    }
  }

  Future<void> _confirmDeleteGroup(String groupId, String groupName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Eliminar grupo"),
        content: Text("¿Seguro que deseas eliminar el grupo $groupName?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    ref.read(groupsProvider.notifier).deleteGroup(groupId);
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.pop();
  }

  Future<void> _confirmRemoveMember({
    required String memberType,
    required String name,
    required VoidCallback onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Eliminar $memberType"),
        content: Text("¿Deseas eliminar al $memberType $name de este grupo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    onConfirm();
  }

  void _removeColporter(String groupId, String name) {
    ref
        .read(groupsProvider.notifier)
        .removeColporter(groupId: groupId, name: name);
  }

  void _removeAssociate(String groupId) {
    ref.read(groupsProvider.notifier).removeAssociate(groupId);
  }
}

class _EditGroupForm extends ConsumerStatefulWidget {
  final ColportorGroup group;
  final VoidCallback onDelete;

  const _EditGroupForm({required this.group, required this.onDelete});

  @override
  ConsumerState<_EditGroupForm> createState() => _EditGroupFormState();
}

class _EditGroupFormState extends ConsumerState<_EditGroupForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
    _descriptionController = TextEditingController(
      text: widget.group.description,
    );
    _imagePath = widget.group.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageName = _imagePath?.split(RegExp(r'[\\/]')).last;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _GroupImage(path: _imagePath),
          AppSpacing.heightSmall,
          TextFormat.subtitle(widget.group.name),
          AppSpacing.heightSmall,
          TextFormat.bodySecondary(
            "Zona asignada: ${widget.group.assignedZone}",
          ),
          AppSpacing.heightSmall,
          FileUploadFormat(
            label: "Imagen del grupo",
            fileName: imageName,
            fileType: FileType.image,
            allowCamera: false,
            onFileSelected: (path) => setState(() => _imagePath = path),
            onRemove: _imagePath == null
                ? null
                : () => setState(() => _imagePath = null),
          ),
          AppSpacing.heightMedium,
          InputTextFormart(
            labelText: "Nombre del grupo",
            hintText: "Escribe el nombre del grupo",
            controller: _nameController,
            maxLength: 80,
            validator: (value) => value == null || value.trim().isEmpty
                ? "El nombre del grupo es obligatorio"
                : null,
          ),
          AppSpacing.heightMedium,
          InputTextFormart(
            labelText: "Descripción",
            hintText: "Escribe una descripción",
            controller: _descriptionController,
            maxLength: 500,
            maxLines: 4,
            minLines: 3,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: widget.onDelete,
              style: TextButton.styleFrom(
                foregroundColor: AppColor.error,
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                side: const BorderSide(color: AppColor.error),
              ),
              icon: IconTheme(
                data: const IconThemeData(color: AppColor.error),
                child: AppIcon.delete,
              ),
              label: TextFormat.label(
                "Eliminar grupo",
                color: AppColor.error,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          AppSpacing.heightMedium,
          ButtonFormat.primary(label: "Guardar cambios", onPressed: _save),
          ButtonFormat.secondary(
            label: "Cancelar",
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    var confirmed = false;
    await DialogFormat(
      title: "Confirmar cambios",
      content: TextFormat.body(
        "¿Estás seguro de guardar los cambios del grupo?",
      ),
      onPressed: () => confirmed = true,
    ).show(context);
    if (!confirmed || !mounted) return;

    ref
        .read(groupsProvider.notifier)
        .updateGroupDetails(
          groupId: widget.group.id,
          name: _nameController.text,
          description: _descriptionController.text,
          imagePath: _imagePath,
          clearImagePath: _imagePath == null,
        );
    Navigator.pop(context);
  }
}

class _GroupImage extends StatelessWidget {
  final String? path;

  const _GroupImage({this.path});

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return Container(
        height: 180,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: AppSpacing.borderSmall,
        ),
        child: AppIcon.grupos,
      );
    }

    return ClipRRect(
      borderRadius: AppSpacing.borderSmall,
      child: Image.file(
        File(path!),
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          height: 180,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: AppIcon.grupos,
        ),
      ),
    );
  }
}

class _TextPromptDialog extends StatefulWidget {
  final String title;
  final String label;
  final String initialValue;
  final int maxLines;

  const _TextPromptDialog({
    required this.title,
    required this.label,
    required this.initialValue,
    required this.maxLines,
  });

  @override
  State<_TextPromptDialog> createState() => _TextPromptDialogState();
}

class _TextPromptDialogState extends State<_TextPromptDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          maxLines: widget.maxLines,
          decoration: InputDecoration(labelText: widget.label),
          validator: (value) => value == null || value.trim().isEmpty
              ? "Este campo es obligatorio"
              : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            Navigator.pop(context, _controller.text);
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
