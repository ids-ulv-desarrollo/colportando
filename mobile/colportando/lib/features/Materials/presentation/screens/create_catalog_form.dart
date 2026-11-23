import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/Materials/domain/entities/material_catalog.dart';
import 'package:colportando/features/Materials/domain/entities/material_category.dart';
import 'package:colportando/features/Materials/presentation/riverpod/catalogs_riverpod.dart';
import 'package:colportando/features/Materials/presentation/riverpod/categories_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCatalogForm extends ConsumerStatefulWidget {
  final List<String> availableBooks;
  final List<String> availableCategories;

  const CreateCatalogForm({
    super.key,
    this.availableBooks = const [],
    this.availableCategories = const [],
  });

  @override
  ConsumerState<CreateCatalogForm> createState() => _CreateCatalogFormState();
}

class _CreateCatalogFormState extends ConsumerState<CreateCatalogForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _createdAt = DateTime.now();
  final _selectedBooks = <String>{};
  final _selectedCategories = <String>{};

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!await _confirm(
      title: 'Confirmar catálogo',
      message: '¿Deseas crear este catálogo?',
      confirmLabel: 'Crear',
    )) {
      return;
    }

    final created = ref
        .read(catalogsProvider.notifier)
        .createCatalog(
          name: _nameController.text,
          description: _descriptionController.text,
          campaign: activeCatalogCampaign,
          status: activeCatalogStatus,
          bookIds: _selectedBooks.toList(),
          categoryIds: _selectedCategories.toList(),
        );
    if (created && mounted) {
      Navigator.pop(context, true);
      return;
    }

    if (mounted) {
      SnackBarFormat().show(
        context,
        'Ya existe un catálogo con ese nombre.',
        isError: true,
      );
    }
  }

  Future<void> _cancel() async {
    if (await _confirm(
      title: 'Cancelar creación',
      message: '¿Deseas cancelar? Se perderán los datos ingresados.',
      confirmLabel: 'Cancelar',
    )) {
      if (mounted) Navigator.pop(context);
    }
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Volver'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmLabel),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _selectItems({
    required String title,
    required List<String> items,
    required Set<String> selectedItems,
  }) async {
    final selected = Set<String>.from(selectedItems);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: items.isEmpty
              ? const Text('No hay elementos disponibles para seleccionar.')
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final item in items)
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
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogs = ref.watch(catalogsProvider);
    final categoryNames = {
      ...widget.availableCategories,
      ...ref
          .watch(categoriesProvider)
          .where((category) => category.status == activeCategoryStatus)
          .map((category) => category.name),
    }.toList();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputTextFormart(
            labelText: 'Nombre del catálogo',
            hintText: 'Escribe el nombre del catálogo',
            controller: _nameController,
            maxLength: 80,
            validator: (value) {
              final name = value?.trim() ?? '';
              if (name.isEmpty) return 'Escribe el nombre del catálogo';
              if (catalogs.any(
                (catalog) => catalog.name.toLowerCase() == name.toLowerCase(),
              )) {
                return 'Ya existe un catálogo con ese nombre';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          InputTextFormart(
            labelText: 'Descripción',
            hintText: 'Describe el catálogo',
            controller: _descriptionController,
            maxLength: 500,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormat.label('Campaña'),
          const SizedBox(height: 4),
          const InputDecorator(
            decoration: InputDecoration(suffixIcon: Icon(Icons.lock_outline)),
            child: Text('Campaña activa (se asignará automáticamente)'),
          ),
          const SizedBox(height: 16),
          _selectionButton(
            label: 'Seleccionar libros',
            count: _selectedBooks.length,
            onPressed: () => _selectItems(
              title: 'Libros del catálogo',
              items: widget.availableBooks,
              selectedItems: _selectedBooks,
            ),
          ),
          const SizedBox(height: 8),
          _selectionButton(
            label: 'Seleccionar categorías',
            count: _selectedCategories.length,
            onPressed: () => _selectItems(
              title: 'Categorías del catálogo',
              items: categoryNames,
              selectedItems: _selectedCategories,
            ),
          ),
          const SizedBox(height: 12),
          TextFormat.subtitle('Libros incluidos: ${_selectedBooks.length}'),
          const SizedBox(height: 8),
          TextFormat.subtitle('Fecha de creación: ${_formatDate(_createdAt)}'),
          const SizedBox(height: 16),
          ButtonFormat.primary(
            label: 'Crear catálogo',
            formKey: _formKey,
            onPressed: _save,
          ),
          ButtonFormat.secondary(label: 'Cancelar', onPressed: _cancel),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
