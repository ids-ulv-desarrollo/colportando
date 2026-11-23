import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/filter_chip_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/Materials/domain/entities/material_category.dart';
import 'package:colportando/features/Materials/presentation/riverpod/books_riverpod.dart';
import 'package:colportando/features/Materials/presentation/riverpod/categories_riverpod.dart';
import 'package:colportando/features/Materials/presentation/screens/create_category_form.dart';
import 'package:colportando/features/Materials/presentation/screens/detail_category_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  final List<String> availableBooks;

  const CategoriesScreen({super.key, this.availableBooks = const []});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  String _search = '';
  _CategoryStatusFilter _statusFilter = _CategoryStatusFilter.all;
  _CategorySort _sort = _CategorySort.nameAscending;

  @override
  Widget build(BuildContext context) {
    final categories = _filteredCategories(ref.watch(categoriesProvider));
    final availableBooks = {
      ...widget.availableBooks,
      ...ref.watch(booksProvider).map((book) => book.name),
    }.toList();

    return ScaffoldFormat(
      titleAppBar: 'Categorías',
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar categoría',
        onPressed: () => BottomSheetFormat.content(
          CreateCategoryForm(availableBooks: availableBooks),
          title: 'Nueva categoría',
        ).show(context),
        child: AppIcon.add,
      ),
      children: [
        InputTextFormart(
          hintText: 'Buscar categoría',
          onChanged: (value) => setState(() => _search = value.trim()),
          maxLength: 50,
          prefixIcon: AppIcon.search,
        ),
        AppSpacing.heightSmall,
        ListViewFormat(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            return switch (index) {
              0 => FilterChipFormat(
                label: 'Todos',
                isSelected: _statusFilter == _CategoryStatusFilter.all,
                onSelected: (_) =>
                    setState(() => _statusFilter = _CategoryStatusFilter.all),
              ),
              1 => FilterChipFormat(
                label: _statusFilter == _CategoryStatusFilter.inactive
                    ? 'Desactivadas'
                    : 'Activas',
                isSelected:
                    _statusFilter == _CategoryStatusFilter.active ||
                    _statusFilter == _CategoryStatusFilter.inactive,
                onSelected: (_) => setState(
                  () => _statusFilter =
                      _statusFilter == _CategoryStatusFilter.active
                      ? _CategoryStatusFilter.inactive
                      : _CategoryStatusFilter.active,
                ),
              ),
              2 => FilterChipFormat(
                label: _sort == _CategorySort.sizeDescending
                    ? 'Tamaño: Descendente'
                    : 'Tamaño: Ascendente',
                isSelected:
                    _sort == _CategorySort.sizeDescending ||
                    _sort == _CategorySort.sizeAscending,
                onSelected: (_) => setState(
                  () => _sort = _sort == _CategorySort.sizeDescending
                      ? _CategorySort.sizeAscending
                      : _CategorySort.sizeDescending,
                ),
              ),
              _ => FilterChipFormat(
                label: _sort == _CategorySort.nameDescending
                    ? 'Nombre: Z-A'
                    : 'Nombre: A-Z',
                isSelected:
                    _sort == _CategorySort.nameAscending ||
                    _sort == _CategorySort.nameDescending,
                onSelected: (_) => setState(
                  () => _sort = _sort == _CategorySort.nameAscending
                      ? _CategorySort.nameDescending
                      : _CategorySort.nameAscending,
                ),
              ),
            };
          },
        ),
        AppSpacing.heightMedium,
        ListViewFormat(
          itemCount: categories.length,
          emptyWidget: AppIcon.categoria,
          emptyMessage: 'No hay categorías que coincidan.',
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryTile(
              category: category,
              availableBooks: availableBooks,
            );
          },
        ),
      ],
    );
  }

  List<MaterialCategory> _filteredCategories(
    List<MaterialCategory> categories,
  ) {
    final filtered = categories.where((category) {
      final matchesSearch = category.name.toLowerCase().contains(
        _search.toLowerCase(),
      );
      final matchesStatus =
          _statusFilter == _CategoryStatusFilter.all ||
          category.status ==
              (_statusFilter == _CategoryStatusFilter.active
                  ? activeCategoryStatus
                  : inactiveCategoryStatus);
      return matchesSearch && matchesStatus;
    }).toList();

    filtered.sort(
      (a, b) => switch (_sort) {
        _CategorySort.sizeDescending => b.bookCount.compareTo(a.bookCount),
        _CategorySort.sizeAscending => a.bookCount.compareTo(b.bookCount),
        _CategorySort.nameDescending => b.name.toLowerCase().compareTo(
          a.name.toLowerCase(),
        ),
        _CategorySort.nameAscending => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
      },
    );
    return filtered;
  }
}

enum _CategoryStatusFilter { all, active, inactive }

enum _CategorySort {
  sizeDescending,
  sizeAscending,
  nameAscending,
  nameDescending,
}

class _CategoryTile extends StatelessWidget {
  final MaterialCategory category;
  final List<String> availableBooks;

  const _CategoryTile({required this.category, required this.availableBooks});

  @override
  Widget build(BuildContext context) {
    return ContainerListTile(
      title: category.name,
      subtitle: '${category.bookCount} libros incluidos',
      subsubtitle: _StatusBadge(status: category.status),
      icon: AppIcon.categoria,
      expandedChild: [
        Padding(
          padding: AppSpacing.paddingSymetric8_0,
          child: ButtonFormat.primary(
            label: 'Ver detalles',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailCategoryForm(
                  category: category,
                  availableBooks: availableBooks,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
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
