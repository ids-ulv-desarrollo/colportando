import 'dart:io';

import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/book_card_format.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/filter_chip_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/Materials/domain/entities/material_book.dart';
import 'package:colportando/features/Materials/presentation/riverpod/books_riverpod.dart';
import 'package:colportando/features/Materials/presentation/riverpod/categories_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCategoryForm extends ConsumerStatefulWidget {
  final List<String> availableBooks;
  final Set<String> initialSelected;

  const CreateCategoryForm({
    super.key,
    this.availableBooks = const [],
    this.initialSelected = const <String>{},
  });

  @override
  ConsumerState<CreateCategoryForm> createState() => _CreateCategoryFormState();
}

class _CreateCategoryFormState extends ConsumerState<CreateCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final Set<String> _selectedBooks;
  String? _errorMessage;
  int _descriptionWordCount = 0;

  @override
  void initState() {
    super.initState();
    _selectedBooks = Set<String>.from(widget.initialSelected);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedBooks.isEmpty) {
      setState(() => _errorMessage = 'Debe contener al menos 1 libro');
      return;
    }
    setState(() => _errorMessage = null);

    final confirmed = await _confirm(
      title: 'Crear categoría',
      message: '¿Deseas crear esta categoría?',
      confirmLabel: 'Crear',
    );
    if (!confirmed || !mounted) return;

    final created = ref
        .read(categoriesProvider.notifier)
        .createCategory(
          name: _nameController.text,
          description: _descriptionController.text,
          bookIds: _selectedBooks.toList(),
        );
    if (created) {
      SnackBarFormat().show(context, 'Categoría creada correctamente');
      Navigator.pop(context, _nameController.text.trim());
      return;
    }

    SnackBarFormat().show(
      context,
      'Ya existe una categoría con ese nombre.',
      isError: true,
    );
  }

  Future<void> _cancel() async {
    final confirmed = await _confirm(
      title: 'Cancelar creación',
      message: '¿Deseas cancelar? Se perderán los datos ingresados.',
      confirmLabel: 'Cancelar',
    );
    if (confirmed && mounted) Navigator.pop(context);
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    var confirmed = false;
    await DialogFormat(
      title: title,
      content: Text(message),
      onPressed: () => confirmed = true,
    ).show(context);
    return confirmed;
  }

  Future<void> _selectBooks() async {
    final selected = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _CategoryBookSelector(
        availableBooks: widget.availableBooks,
        initialSelected: _selectedBooks,
      ),
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedBooks
          ..clear()
          ..addAll(selected);
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputTextFormart(
            labelText: 'Nombre de la categoría',
            hintText: 'Escribe el nombre de la categoría',
            controller: _nameController,
            maxLength: 80,
            validator: (value) {
              final name = value?.trim() ?? '';
              if (name.isEmpty) return 'Escribe el nombre de la categoría';
              if (categories.any(
                (category) => category.name.toLowerCase() == name.toLowerCase(),
              )) {
                return 'Ya existe una categoría con ese nombre';
              }
              return null;
            },
          ),
          AppSpacing.heightMedium,
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
          OutlinedButton(
            onPressed: _selectBooks,
            child: Row(
              children: [
                const Expanded(child: Text('Seleccionar libros')),
                Text('${_selectedBooks.length} seleccionados'),
                AppIcon.arrowRight,
              ],
            ),
          ),
          if (_errorMessage != null) ...[
            AppSpacing.heightSmall,
            TextFormat.bodySecondary(
              _errorMessage!,
              color: AppColor.error,
              fontWeight: FontWeight.w700,
            ),
          ],
          AppSpacing.heightMedium,
          ButtonFormat.primary(
            label: 'Crear categoría',
            formKey: _formKey,
            onPressed: _save,
          ),
          ButtonFormat.secondary(label: 'Cancelar', onPressed: _cancel),
        ],
      ),
    );
  }
}

class _CategoryBookSelector extends ConsumerStatefulWidget {
  final List<String> availableBooks;
  final Set<String> initialSelected;

  const _CategoryBookSelector({
    required this.availableBooks,
    required this.initialSelected,
  });

  @override
  ConsumerState<_CategoryBookSelector> createState() =>
      _CategoryBookSelectorState();
}

class _CategoryBookSelectorState extends ConsumerState<_CategoryBookSelector> {
  String _search = '';
  _SelectorFilter _filter = _SelectorFilter.all;
  _SelectorSort _sort = _SelectorSort.nameAscending;
  bool _showFavorites = false;
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    final availableNames = {
      ...widget.availableBooks,
      ...ref.watch(booksProvider).map((book) => book.name),
    };
    final books = _filteredBooks(
      ref
          .watch(booksProvider)
          .where((book) => availableNames.contains(book.name))
          .toList(),
    );

    return SafeArea(
      child: Padding(
        padding: AppSpacing.paddingMedium,
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.82,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormat.subtitle('Libros de la categoría'),
              AppSpacing.heightSmall,
              InputTextFormart(
                hintText: 'Buscar libro',
                onChanged: (value) => setState(() => _search = value.trim()),
                maxLength: 50,
                prefixIcon: AppIcon.search,
              ),
              AppSpacing.heightSmall,
              ListViewFormat(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return switch (index) {
                    0 => FilterChipFormat(
                      label: '',
                      icon: Icon(
                        _showFavorites
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: _showFavorites ? AppColor.warning : null,
                      ),
                      isSelected: _showFavorites,
                      onSelected: (value) =>
                          setState(() => _showFavorites = value),
                    ),
                    1 => FilterChipFormat(
                      label: 'Todos',
                      isSelected: _filter == _SelectorFilter.all,
                      onSelected: (_) =>
                          setState(() => _filter = _SelectorFilter.all),
                    ),
                    2 => FilterChipFormat(
                      label: _filter == _SelectorFilter.noBonificable
                          ? 'No bonificable'
                          : 'Bonificable',
                      isSelected:
                          _filter == _SelectorFilter.bonificable ||
                          _filter == _SelectorFilter.noBonificable,
                      onSelected: (_) => setState(
                        () => _filter = _filter == _SelectorFilter.bonificable
                            ? _SelectorFilter.noBonificable
                            : _SelectorFilter.bonificable,
                      ),
                    ),
                    3 => FilterChipFormat(
                      label: 'Desactivado',
                      isSelected: _filter == _SelectorFilter.inactive,
                      onSelected: (_) =>
                          setState(() => _filter = _SelectorFilter.inactive),
                    ),
                    _ => FilterChipFormat(
                      label: _sort == _SelectorSort.nameDescending
                          ? 'Nombre: Z-A'
                          : 'Nombre: A-Z',
                      isSelected:
                          _sort == _SelectorSort.nameAscending ||
                          _sort == _SelectorSort.nameDescending,
                      onSelected: (_) => setState(
                        () => _sort = _sort == _SelectorSort.nameAscending
                            ? _SelectorSort.nameDescending
                            : _SelectorSort.nameAscending,
                      ),
                    ),
                  };
                },
              ),
              AppSpacing.heightMedium,
              Expanded(
                child: books.isEmpty
                    ? ListViewFormat(
                        itemCount: 0,
                        emptyWidget: AppIcon.libro,
                        emptyMessage: 'No hay libros que coincidan.',
                        itemBuilder: (_, _) => const SizedBox.shrink(),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth >= 720
                              ? 3
                              : 2;
                          final cardWidth =
                              (constraints.maxWidth -
                                  ((crossAxisCount - 1) * 16)) /
                              crossAxisCount;
                          return SingleChildScrollView(
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                for (final book in books)
                                  SizedBox(
                                    width: cardWidth,
                                    child: BookCardFormat(
                                      title: book.name,
                                      category: book.category.isEmpty
                                          ? 'Sin categoría'
                                          : book.category,
                                      categoryIsSecondary:
                                          book.category.isEmpty,
                                      categoryCrossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      image: _CategoryBookCover(
                                        path: book.coverPath,
                                      ),
                                      imageHeight: cardWidth * 1.25,
                                      onPressed: () => setState(() {
                                        if (_selected.contains(book.name)) {
                                          _selected.remove(book.name);
                                        } else {
                                          _selected.add(book.name);
                                        }
                                      }),
                                      titleTrailing: _CategoryStatusBadge(
                                        status: book.status,
                                      ),
                                      trailingAction: Icon(
                                        _selected.contains(book.name)
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: _selected.contains(book.name)
                                            ? AppColor.primary
                                            : AppColor.gray,
                                      ),
                                      leadingActionAtBottom: true,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              AppSpacing.heightSmall,
              TextFormat.subtitle('${_selected.length} seleccionados'),
              AppSpacing.heightSmall,
              Row(
                children: [
                  Expanded(
                    child: ButtonFormat.secondary(
                      label: 'Cancelar',
                      onPressed: _cancel,
                    ),
                  ),
                  AppSpacing.widthMedium,
                  Expanded(
                    child: ButtonFormat.primary(
                      label: 'Agregar',
                      onPressed: _add,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<MaterialBook> _filteredBooks(List<MaterialBook> books) {
    final filtered = books.where((book) {
      final matchesSearch = book.name.toLowerCase().contains(
        _search.toLowerCase(),
      );
      final matchesFavorites = !_showFavorites || book.isFavorite;
      final matchesFilter = switch (_filter) {
        _SelectorFilter.all => true,
        _SelectorFilter.bonificable => book.status == bonificableStatus,
        _SelectorFilter.noBonificable => book.status == noBonificableStatus,
        _SelectorFilter.inactive => book.status == inactiveBookStatus,
      };
      return matchesSearch && matchesFilter && matchesFavorites;
    }).toList();

    filtered.sort(
      (a, b) => _sort == _SelectorSort.nameAscending
          ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
          : b.name.toLowerCase().compareTo(a.name.toLowerCase()),
    );
    return filtered;
  }

  Future<void> _cancel() async {
    final confirmed = await _confirm(
      title: 'Cancelar selección',
      message: '¿Deseas cancelar? Los cambios no se agregarán.',
      confirmLabel: 'Cancelar',
    );
    if (confirmed && mounted) Navigator.pop(context);
  }

  Future<void> _add() async {
    final confirmed = await _confirm(
      title: 'Agregar libros',
      message: '¿Deseas agregar los libros seleccionados?',
      confirmLabel: 'Agregar',
    );
    if (confirmed && mounted) {
      Navigator.pop(context, Set<String>.from(_selected));
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
}

enum _SelectorFilter { all, bonificable, noBonificable, inactive }

enum _SelectorSort { nameAscending, nameDescending }

class _CategoryBookCover extends StatelessWidget {
  final String? path;

  const _CategoryBookCover({required this.path});

  @override
  Widget build(BuildContext context) {
    final hasCover = path != null && path!.isNotEmpty;
    return ClipRRect(
      borderRadius: AppSpacing.borderSmall,
      child: hasCover
          ? Image.file(
              File(path!),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(color: AppColor.gray.withOpacity(0.15)),
            )
          : Container(color: AppColor.gray.withOpacity(0.15)),
    );
  }
}

class _CategoryStatusBadge extends StatelessWidget {
  final String status;

  const _CategoryStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == bonificableStatus
        ? AppColor.primary
        : status == noBonificableStatus
        ? AppColor.error
        : AppColor.gray;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: AppSpacing.borderSmall,
      ),
      child: TextFormat.label(
        status,
        color: color,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
