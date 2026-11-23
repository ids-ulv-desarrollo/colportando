import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/Materials/domain/entities/material_catalog.dart';
import 'package:colportando/features/Materials/domain/entities/material_category.dart';
import 'package:colportando/features/Materials/presentation/riverpod/catalogs_riverpod.dart';
import 'package:colportando/features/Materials/presentation/riverpod/categories_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailCatalogForm extends ConsumerStatefulWidget {
  final MaterialCatalog catalog;
  final List<String> availableBooks;
  final List<String> availableCategories;

  const DetailCatalogForm({
    super.key,
    required this.catalog,
    this.availableBooks = const [],
    this.availableCategories = const [],
  });

  @override
  ConsumerState<DetailCatalogForm> createState() => _DetailCatalogFormState();
}

class _DetailCatalogFormState extends ConsumerState<DetailCatalogForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late Set<String> _selectedBooks;
  late Set<String> _selectedCategories;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.catalog.name);
    _descriptionController = TextEditingController(
      text: widget.catalog.description,
    );
    _selectedBooks = {...widget.catalog.bookIds};
    _selectedCategories = {...widget.catalog.categoryIds};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: 'Detalle del catálogo',
      children: [
        if (_isEditing)
          Form(key: _formKey, child: _buildContent())
        else
          _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    final categoryNames = {
      ...widget.availableCategories,
      ...ref
          .watch(categoriesProvider)
          .where((category) => category.status == activeCategoryStatus)
          .map((category) => category.name),
    }.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isEditing)
          InputTextFormart(
            labelText: 'Nombre del catálogo',
            hintText: 'Escribe el nombre del catálogo',
            controller: _nameController,
            maxLength: 80,
            validator: (value) => value?.trim().isEmpty ?? true
                ? 'Escribe el nombre del catálogo'
                : null,
          )
        else
          TextFormat.title(widget.catalog.name),
        AppSpacing.heightMedium,
        if (_isEditing)
          InputTextFormart(
            labelText: 'Descripción',
            hintText: 'Describe el catálogo',
            controller: _descriptionController,
            maxLength: 500,
            maxLines: 3,
          )
        else ...[
          TextFormat.subtitle('Descripción'),
          AppSpacing.heightSmall,
          TextFormat.bodySecondary(
            widget.catalog.description.isEmpty
                ? 'Sin descripción'
                : widget.catalog.description,
          ),
        ],
        AppSpacing.heightMedium,
        _detail('Campaña', widget.catalog.campaign),
        _statusDetail(),
        _detail('Fecha de creación', _formatDate(widget.catalog.createdAt)),
        TextFormat.subtitle('Libros incluidos'),
        AppSpacing.heightSmall,
        if (_isEditing)
          _selectionButton(
            label: 'Seleccionar libros',
            count: _selectedBooks.length,
            onPressed: () => _selectItems(
              title: 'Libros del catálogo',
              items: widget.availableBooks,
              selectedItems: _selectedBooks,
            ),
          )
        else
          _selectedItems(widget.catalog.bookIds),
        AppSpacing.heightMedium,
        TextFormat.subtitle('Categorías incluidas'),
        AppSpacing.heightSmall,
        if (_isEditing)
          _selectionButton(
            label: 'Seleccionar categorías',
            count: _selectedCategories.length,
            onPressed: () => _selectItems(
              title: 'Categorías del catálogo',
              items: categoryNames,
              selectedItems: _selectedCategories,
            ),
          )
        else
          _selectedItems(widget.catalog.categoryIds),
        AppSpacing.heightMedium,
        if (_isEditing) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _confirmDelete,
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
                'Eliminar catálogo',
                color: AppColor.error,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          AppSpacing.heightSmall,
          Row(
            children: [
              Expanded(
                child: ButtonFormat.secondary(
                  label: 'Cancelar',
                  onPressed: _cancelEditing,
                ),
              ),
              AppSpacing.widthSmall,
              Expanded(
                child: ButtonFormat.primary(
                  label: 'Guardar',
                  formKey: _formKey,
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: ButtonFormat.secondary(
                  label: 'Cancelar',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              AppSpacing.widthSmall,
              Expanded(
                child: ButtonFormat.primary(
                  icon: AppIcon.edit,
                  label: 'Editar',
                  onPressed: () => setState(() => _isEditing = true),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormat.label(label, color: AppColor.gray),
          TextFormat.body(value),
        ],
      ),
    );
  }

  Widget _statusDetail() {
    final color = _getStatusColor(widget.catalog.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormat.label('Estado', color: AppColor.gray),
          Container(
            height: 20,
            width: 85,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: AppSpacing.borderMedium,
            ),
            padding: const EdgeInsets.only(top: 2),
            child: TextFormat.label(
              widget.catalog.status,
              textAlign: TextAlign.center,
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedItems(List<String> items) {
    if (items.isEmpty) return TextFormat.bodySecondary('Ninguno seleccionado.');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: TextFormat.bodySecondary('• $item'),
          ),
      ],
    );
  }

  Widget _selectionButton({
    required String label,
    required int count,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text('$count seleccionados'),
          AppIcon.arrowRight,
        ],
      ),
    );
  }

  Future<void> _selectItems({
    required String title,
    required List<String> items,
    required Set<String> selectedItems,
  }) async {
    final selected = Set<String>.from(selectedItems);
    final selectableItems = {...items, ...selectedItems}.toList();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: selectableItems.isEmpty
              ? const Text('No hay elementos disponibles para seleccionar.')
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final item in selectableItems)
                        CheckboxListTile(
                          value: selected.contains(item),
                          title: Text(item),
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) => setDialogState(() {
                            if (value == true) {
                              selected.add(item);
                            } else {
                              selected.remove(item);
                            }
                          }),
                        ),
                    ],
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        selectedItems
          ..clear()
          ..addAll(selected);
      });
    }
  }

  Future<void> _cancelEditing() async {
    final confirmed = await _confirm(
      title: 'Cancelar edición',
      message: '¿Deseas descartar los cambios realizados?',
    );
    if (!confirmed || !mounted) return;

    setState(() {
      _nameController.text = widget.catalog.name;
      _descriptionController.text = widget.catalog.description;
      _selectedBooks = {...widget.catalog.bookIds};
      _selectedCategories = {...widget.catalog.categoryIds};
      _isEditing = false;
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final confirmed = await _confirm(
      title: 'Confirmar cambios',
      message: widget.catalog.status == closedCatalogStatus
          ? 'El catálogo está cerrado. Se creará uno nuevo con estos cambios.'
          : '¿Deseas guardar los cambios del catálogo?',
    );
    if (!confirmed || !mounted) return;

    final notifier = ref.read(catalogsProvider.notifier);
    final updated = widget.catalog.status == closedCatalogStatus
        ? notifier.createCatalogVersion(
            name: _nameController.text,
            description: _descriptionController.text,
            campaign: activeCatalogCampaign,
            bookIds: _selectedBooks.toList(),
            categoryIds: _selectedCategories.toList(),
          )
        : notifier.updateCatalog(
            originalCatalog: widget.catalog,
            name: _nameController.text,
            description: _descriptionController.text,
            bookIds: _selectedBooks.toList(),
            categoryIds: _selectedCategories.toList(),
          );
    if (!updated) {
      SnackBarFormat().show(
        context,
        'No se pudo guardar el catálogo. Verifica el nombre.',
        isError: true,
      );
      return;
    }
    Navigator.pop(context);
  }

  Future<void> _confirmDelete() async {
    final isActive = widget.catalog.status == activeCatalogStatus;
    final confirmed = await _confirm(
      title: 'Eliminar catálogo',
      message: isActive
          ? 'El catálogo se moverá a Otros. ¿Deseas continuar?'
          : '¿Deseas eliminar permanentemente el catálogo "${widget.catalog.name}"?',
    );
    if (!confirmed || !mounted) return;
    final notifier = ref.read(catalogsProvider.notifier);
    if (isActive) {
      notifier.closeCatalog(widget.catalog);
    } else {
      notifier.deleteCatalog(widget.catalog);
    }
    Navigator.pop(context);
  }

  Future<bool> _confirm({
    required String title,
    required String message,
  }) async {
    var confirmed = false;
    await DialogFormat(
      title: title,
      content: TextFormat.body(message),
      onPressed: () => confirmed = true,
    ).show(context);
    return confirmed;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

Color _getStatusColor(String status) {
  return switch (status) {
    activeCatalogStatus => AppColor.primary,
    closedCatalogStatus => AppColor.gray,
    "Programado" => AppColor.info,
    _ => AppColor.warning,
  };
}
