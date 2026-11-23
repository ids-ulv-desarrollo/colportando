import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/Materials/domain/entities/material_category.dart';
import 'package:colportando/features/Materials/presentation/riverpod/categories_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailCategoryForm extends ConsumerStatefulWidget {
  final MaterialCategory category;
  final List<String> availableBooks;

  const DetailCategoryForm({
    super.key,
    required this.category,
    this.availableBooks = const [],
  });

  @override
  ConsumerState<DetailCategoryForm> createState() => _DetailCategoryFormState();
}

class _DetailCategoryFormState extends ConsumerState<DetailCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late Set<String> _selectedBooks;
  bool _isEditing = false;
  late int _descriptionWordCount;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(
      text: widget.category.description,
    );
    _descriptionWordCount = TextFormat.descriptionWordCount(
      widget.category.description,
    );
    _selectedBooks = {...widget.category.bookIds};
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
      titleAppBar: 'Detalle de la categoría',
      children: [
        if (_isEditing) Form(key: _formKey, child: _content()) else _content(),
      ],
    );
  }

  Widget _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isEditing)
          InputTextFormart(
            labelText: 'Nombre de la categoría',
            hintText: 'Escribe el nombre de la categoría',
            controller: _nameController,
            maxLength: 80,
            validator: (value) => value?.trim().isEmpty ?? true
                ? 'Escribe el nombre de la categoría'
                : null,
          )
        else
          TextFormat.title(widget.category.name),
        AppSpacing.heightMedium,
        if (_isEditing)
          InputTextFormart(
            labelText: 'Descripción',
            hintText: 'Describe la categoría',
            controller: _descriptionController,
            maxLength: 500,
            maxLines: 3,
            inputFormatters: [
              const WordLimitTextInputFormatter(
                maxWords: TextFormat.descriptionWordLimit,
              ),
            ],
            onChanged: (value) => setState(
              () => _descriptionWordCount =
                  TextFormat.descriptionWordCount(value),
            ),
          )
        else
          const SizedBox.shrink(),
        if (_isEditing)
          Align(
            alignment: Alignment.centerRight,
            child: TextFormat.label(
              '$_descriptionWordCount/${TextFormat.descriptionWordLimit} palabras',
              color: _descriptionWordCount == TextFormat.descriptionWordLimit
                  ? AppColor.warning
                  : AppColor.gray,
            ),
          )
        else ...[
          TextFormat.subtitle('Descripción'),
          AppSpacing.heightSmall,
          TextFormat.bodySecondary(
            TextFormat.descriptionPreview(widget.category.description),
          ),
        ],
        AppSpacing.heightMedium,
        _detail('Estado', _StatusBadge(status: widget.category.status)),
        _detail(
          'Fecha de creación',
          TextFormat.bodySecondary(_formatDate(widget.category.createdAt)),
        ),
        TextFormat.subtitle('Libros incluidos'),
        AppSpacing.heightSmall,
        if (_isEditing)
          OutlinedButton(
            onPressed: _selectBooks,
            child: Row(
              children: [
                const Expanded(child: Text('Seleccionar libros')),
                Text('${_selectedBooks.length} seleccionados'),
                AppIcon.arrowRight,
              ],
            ),
          )
        else
          _selectedItems(widget.category.bookIds),
        AppSpacing.heightMedium,
        if (_isEditing) ...[
          ButtonFormat.secondary(
            label: widget.category.status == activeCategoryStatus
                ? 'Desactivar categoría'
                : 'Activar categoría',
            onPressed: _toggleStatus,
          ),
          AppSpacing.heightSmall,
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
                'Eliminar categoría',
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
          ButtonFormat.primary(
            label: 'Editar',
            onPressed: () => setState(() => _isEditing = true),
          ),
          ButtonFormat.secondary(
            label: 'Cancelar',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ],
    );
  }

  Widget _detail(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormat.label(label, color: AppColor.gray),
          value,
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

  Future<void> _selectBooks() async {
    final selected = Set<String>.from(_selectedBooks);
    final items = {...widget.availableBooks, ...selected}.toList();
    if (items.isEmpty) {
      await DialogFormat(
        title: 'Seleccionar libros',
        content: const Text('No hay libros disponibles para agregar.'),
        onPressed: () {},
      ).show(context);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Libros de la categoría'),
          content: ListView(
            shrinkWrap: true,
            children: [
              for (final book in items)
                CheckboxListTile(
                  value: selected.contains(book),
                  title: Text(book),
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) => setDialogState(() {
                    if (value == true) {
                      selected.add(book);
                    } else {
                      selected.remove(book);
                    }
                  }),
                ),
            ],
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
        _selectedBooks
          ..clear()
          ..addAll(selected);
      });
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedBooks.isEmpty) {
      SnackBarFormat().show(
        context,
        'Una categoría debe tener al menos un libro.',
        isError: true,
      );
      return;
    }
    if (!await _confirm(
      title: 'Guardar cambios',
      message: '¿Deseas guardar los cambios de la categoría?',
    )) {
      return;
    }

    final updated = ref
        .read(categoriesProvider.notifier)
        .updateCategory(
          originalCategory: widget.category,
          name: _nameController.text,
          description: _descriptionController.text,
          bookIds: _selectedBooks.toList(),
        );
    if (!updated) {
      SnackBarFormat().show(
        context,
        'No se pudo guardar la categoría. Verifica el nombre.',
        isError: true,
      );
      return;
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _cancelEditing() async {
    if (!await _confirm(
      title: 'Cancelar edición',
      message: '¿Deseas descartar los cambios realizados?',
    )) {
      return;
    }
    if (!mounted) return;
    setState(() {
      _nameController.text = widget.category.name;
      _descriptionController.text = widget.category.description;
      _selectedBooks = {...widget.category.bookIds};
      _isEditing = false;
    });
  }

  Future<void> _confirmDelete() async {
    if (!await _confirm(
      title: 'Eliminar categoría',
      message: '¿Deseas eliminar "${widget.category.name}"?',
    )) {
      return;
    }
    if (!mounted) return;
    ref.read(categoriesProvider.notifier).deleteCategory(widget.category);
    Navigator.pop(context);
  }

  Future<void> _toggleStatus() async {
    final isActive = widget.category.status == activeCategoryStatus;
    if (!await _confirm(
      title: isActive ? 'Desactivar categoría' : 'Activar categoría',
      message: isActive
          ? '¿Deseas desactivar esta categoría?'
          : '¿Deseas activar esta categoría?',
    )) {
      return;
    }
    if (!mounted) return;
    ref.read(categoriesProvider.notifier).toggleCategoryStatus(widget.category);
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

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      height: 20,
      width: 95,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: AppSpacing.borderMedium,
      ),
      padding: const EdgeInsets.only(top: 2),
      child: TextFormat.label(
        status,
        textAlign: TextAlign.center,
        color: color,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

Color _getStatusColor(String status) {
  return switch (status) {
    activeCategoryStatus => AppColor.primary,
    inactiveCategoryStatus => AppColor.gray,
    'Programada' => AppColor.info,
    _ => AppColor.warning,
  };
}
