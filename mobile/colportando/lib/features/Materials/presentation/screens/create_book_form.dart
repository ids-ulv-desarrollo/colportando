import 'dart:io';

import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/file_upload_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/Materials/presentation/riverpod/books_riverpod.dart';
import 'package:colportando/features/Materials/presentation/riverpod/categories_riverpod.dart';
import 'package:colportando/features/Materials/presentation/screens/create_category_form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateBookForm extends ConsumerStatefulWidget {
  const CreateBookForm({super.key});

  @override
  ConsumerState<CreateBookForm> createState() => _CreateBookFormState();
}

class _CreateBookFormState extends ConsumerState<CreateBookForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _resourcePaths = <String>[];
  String? _coverPath;
  String? _errorMessage;
  bool _isBonus = false;
  int _descriptionWordCount = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _errorMessage = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_categoryController.text.trim().isEmpty) {
      final withoutCategory = await _confirm(
        title: 'Libro sin categoría',
        message: '¿Quieres crear el libro sin una categoría?',
      );
      if (!withoutCategory || !mounted) return;
    }
    final confirmed = await _confirm(
      title: 'Crear libro',
      message: '¿Deseas crear este libro?',
    );
    if (!confirmed || !mounted) return;

    final book = ref
        .read(booksProvider.notifier)
        .createBook(
          name: _nameController.text,
          description: _descriptionController.text,
          category: _categoryController.text,
          coverPath: _coverPath,
          resourcePaths: _resourcePaths,
          isBonus: _isBonus,
        );
    if (book == null) {
      setState(() => _errorMessage = 'Ya existe un libro con ese nombre.');
      return;
    }

    final categories = ref.read(categoriesProvider);
    if (_categoryController.text.trim().isNotEmpty) {
      final categoryName = _categoryController.text.trim();
      final existingCategory = categories.where(
        (category) => category.name.toLowerCase() == categoryName.toLowerCase(),
      );
      if (existingCategory.isNotEmpty) {
        final category = existingCategory.first;
        final uniqueBookIds = {...category.bookIds, book.name}.toList();
        ref
            .read(categoriesProvider.notifier)
            .updateCategory(
              originalCategory: category,
              name: category.name,
              description: category.description,
              bookIds: uniqueBookIds,
            );
      } else {
        ref
            .read(categoriesProvider.notifier)
            .createCategory(
              name: categoryName,
              description: '',
              bookIds: [book.name],
            );
      }
    }
    SnackBarFormat().show(context, 'Libro creado correctamente');
    Navigator.pop(context, true);
  }

  Future<void> _cancel() async {
    final confirmed = await _confirm(
      title: 'Cancelar creación',
      message: '¿Deseas cancelar? Se perderán los datos ingresados.',
    );
    if (confirmed && mounted) Navigator.pop(context);
  }

  Future<bool> _confirm({
    required String title,
    required String message,
  }) async {
    var confirmed = false;
    await DialogFormat(
      title: title,
      content: Text(message),
      onPressed: () => confirmed = true,
    ).show(context);
    return confirmed;
  }

  Future<void> _selectCategory() async {
    var search = '';
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (_, setSheetState) {
          final categories = ref
              .watch(categoriesProvider)
              .where(
                (category) =>
                    category.name.toLowerCase().contains(search.toLowerCase()),
              )
              .toList();
          return SafeArea(
            child: Padding(
              padding: AppSpacing.paddingMedium,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.65,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormat.subtitle('Seleccionar categoría'),
                    AppSpacing.heightMedium,
                    InputTextFormart(
                      hintText: 'Buscar categoría',
                      onChanged: (value) =>
                          setSheetState(() => search = value.trim()),
                      maxLength: 50,
                      prefixIcon: AppIcon.search,
                    ),
                    AppSpacing.heightMedium,
                    if (categories.isEmpty)
                      Expanded(
                        child: Center(
                          child: TextFormat.bodySecondary(
                            'No hay categorías que coincidan.',
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (final category in categories)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: AppIcon.categoria,
                                title: Text(category.name),
                                subtitle: Text(
                                  '${category.bookCount} libros incluidos',
                                ),
                                trailing:
                                    _categoryController.text == category.name
                                    ? const Icon(Icons.check_circle)
                                    : AppIcon.arrowRight,
                                onTap: () =>
                                    Navigator.pop(sheetContext, category.name),
                              ),
                          ],
                        ),
                      ),
                    AppSpacing.heightMedium,
                    ButtonFormat.secondary(
                      label: 'Crear categoría',
                      onPressed: () async {
                        Navigator.pop(sheetContext);
                        final bookName = _nameController.text.trim();
                        final createdName = await BottomSheetFormat.content(
                          CreateCategoryForm(
                            availableBooks: bookName.isEmpty
                                ? const []
                                : [bookName],
                            initialSelected: bookName.isEmpty
                                ? const <String>{}
                                : {bookName},
                          ),
                          title: 'Nueva categoría',
                        ).show<String>(context);
                        if (createdName != null && mounted) {
                          setState(() {
                            _categoryController.text = createdName;
                            _errorMessage = null;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    if (selected != null && mounted) {
      setState(() {
        _categoryController.text = selected;
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FileUploadFormat(
            label: 'Subir portada',
            fileName: _coverPath,
            fileType: FileType.image,
            allowedExtensions: const ['jpg', 'jpeg', 'png'],
            onFileSelected: (path) => setState(() => _coverPath = path),
            onRemove: () => setState(() => _coverPath = null),
          ),
          if (_coverPath != null) ...[
            AppSpacing.heightSmall,
            ClipRRect(
              borderRadius: AppSpacing.borderSmall,
              child: Image.file(
                File(_coverPath!),
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    TextFormat.bodySecondary('No se pudo mostrar la portada.'),
              ),
            ),
          ],
          AppSpacing.heightMedium,
          InputTextFormart(
            labelText: 'Título',
            hintText: 'Escribe el título del libro',
            controller: _nameController,
            maxLength: 100,
            validator: (value) {
              final name = value?.trim() ?? '';
              if (name.isEmpty) return 'Escribe el título del libro';
              if (books.any(
                (book) => book.name.toLowerCase() == name.toLowerCase(),
              )) {
                return 'Ya existe un libro con ese título';
              }
              return null;
            },
          ),
          AppSpacing.heightMedium,
          InputTextFormart(
            labelText: 'Descripción',
            hintText: 'Describe el libro',
            controller: _descriptionController,
            maxLength: 500,
            maxLines: 3,
            inputFormatters: [
              const WordLimitTextInputFormatter(
                maxWords: TextFormat.descriptionWordLimit,
              ),
            ],
            onChanged: (value) => setState(
              () => _descriptionWordCount = TextFormat.descriptionWordCount(
                value,
              ),
            ),
            validator: (value) {
              final words = TextFormat.descriptionWordCount(value ?? '');
              return words > TextFormat.descriptionWordLimit
                  ? 'La descripción debe tener máximo ${TextFormat.descriptionWordLimit} palabras.'
                  : null;
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextFormat.label(
              '$_descriptionWordCount/${TextFormat.descriptionWordLimit} palabras',
              color: _descriptionWordCount == TextFormat.descriptionWordLimit
                  ? AppColor.warning
                  : AppColor.gray,
            ),
          ),
          AppSpacing.heightMedium,
          OutlinedButton.icon(
            onPressed: _selectCategory,
            icon: AppIcon.categoria,
            label: Text(
              _categoryController.text.isEmpty
                  ? 'Seleccionar categoría'
                  : _categoryController.text,
            ),
          ),
          if (_categoryController.text.isEmpty)
            TextFormat.bodySecondary('La categoría es opcional.'),
          if (_errorMessage != null)
            TextFormat.bodySecondary(
              _errorMessage!,
              color: AppColor.error,
              fontWeight: FontWeight.w700,
            ),
          AppSpacing.heightMedium,
          FileUploadFormat(
            label: 'Agregar recurso',
            allowCamera: false,
            allowMultiple: true,
            fileType: FileType.custom,
            allowedExtensions: const [
              'jpg',
              'jpeg',
              'png',
              'gif',
              'webp',
              'mp4',
              'pdf',
            ],
            onFilesSelected: (paths) => setState(() {
              for (final path in paths) {
                final extension = path.split('.').last.toLowerCase();
                if ([
                      'jpg',
                      'jpeg',
                      'png',
                      'gif',
                      'webp',
                      'mp4',
                      'mov',
                      'avi',
                      'mkv',
                      'webm',
                      'pdf',
                    ].contains(extension) &&
                    !_resourcePaths.contains(path)) {
                  _resourcePaths.add(path);
                }
              }
            }),
          ),
          for (final path in _resourcePaths)
            ListTile(
              dense: true,
              title: Text(path.split(Platform.pathSeparator).last),
              trailing: IconButton(
                icon: AppIcon.cancel,
                onPressed: () => setState(() => _resourcePaths.remove(path)),
              ),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Bonificable'),
            value: _isBonus,
            onChanged: (value) => setState(() => _isBonus = value),
          ),
          ButtonFormat.primary(
            label: 'Crear libro',
            formKey: _formKey,
            onPressed: _save,
          ),
          ButtonFormat.secondary(label: 'Cancelar', onPressed: _cancel),
        ],
      ),
    );
  }
}
