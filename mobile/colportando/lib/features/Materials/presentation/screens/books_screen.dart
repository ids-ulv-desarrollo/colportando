import 'dart:io';

import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/book_card_format.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/filter_chip_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/Materials/domain/entities/material_book.dart';
import 'package:colportando/features/Materials/presentation/riverpod/books_riverpod.dart';
import 'package:colportando/features/Materials/presentation/screens/create_book_form.dart';
import 'package:colportando/features/Materials/presentation/screens/detail_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BooksScreen extends ConsumerStatefulWidget {
  const BooksScreen({super.key});

  @override
  ConsumerState<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends ConsumerState<BooksScreen> {
  String _search = '';
  _BookFilter _filter = _BookFilter.all;
  _BookSort _sort = _BookSort.nameAscending;
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    final books = _filteredBooks(ref.watch(booksProvider));

    return ScaffoldFormat(
      titleAppBar: 'Libros',
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar libro',
        onPressed: () => BottomSheetFormat.content(
          const CreateBookForm(),
          title: 'Nuevo libro',
        ).show(context),
        child: AppIcon.add,
      ),
      children: [
        InputTextFormart(
          hintText: 'Buscar libro',
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
                label: '',
                icon: _FavoriteIcon(isSelected: _showFavorites),
                isSelected: _showFavorites,
                onSelected: (value) => setState(() => _showFavorites = value),
              ),
              1 => FilterChipFormat(
                label: 'Todos',
                isSelected: _filter == _BookFilter.all,
                onSelected: (_) => setState(() => _filter = _BookFilter.all),
              ),
              2 => Builder(
                builder: (chipContext) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showBonusMenu(chipContext),
                  child: FilterChipFormat(
                    label: switch (_filter) {
                      _BookFilter.noBonificable => 'No bonificable',
                      _BookFilter.inactive => 'Desactivado',
                      _ => 'Bonificable',
                    },
                    isSelected:
                        _filter == _BookFilter.bonificable ||
                        _filter == _BookFilter.noBonificable ||
                        _filter == _BookFilter.inactive,
                  ),
                ),
              ),
              _ => Builder(
                builder: (chipContext) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showNameSortMenu(chipContext),
                  child: FilterChipFormat(
                    label: _sort == _BookSort.nameDescending
                        ? 'Nombre: Z-A'
                        : 'Nombre: A-Z',
                    isSelected:
                        _sort == _BookSort.nameAscending ||
                        _sort == _BookSort.nameDescending,
                  ),
                ),
              ),
            };
          },
        ),
        AppSpacing.heightMedium,
        if (books.isEmpty)
          ListViewFormat(
            itemCount: 0,
            emptyWidget: AppIcon.libro,
            emptyMessage: 'No hay libros que coincidan.',
            itemBuilder: (context, index) => const SizedBox.shrink(),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 720 ? 3 : 2;
              final cardWidth =
                  (constraints.maxWidth - ((crossAxisCount - 1) * 16)) /
                  crossAxisCount;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final book in books)
                    SizedBox(
                      width: cardWidth,
                      child: _BookTile(
                        book: book,
                        imageHeight: cardWidth * 1.25,
                        onFavorite: () {
                          final currentBook = ref
                              .read(booksProvider)
                              .firstWhere(
                                (item) => item.name == book.name,
                                orElse: () => book,
                              );
                          final isFavorite = ref
                              .read(booksProvider.notifier)
                              .toggleFavorite(currentBook);
                          SnackBarFormat().show(
                            context,
                            isFavorite
                                ? 'Libro agregado de favoritos'
                                : 'Libro eliminado de favoritos',
                          );
                          return isFavorite;
                        },
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }

  Future<void> _showBonusMenu(BuildContext context) async {
    final renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final rect = position & renderBox.size;

    final selected = await showMenu<_BookFilter>(
      context: context,
      position: RelativeRect.fromRect(rect, Offset.zero & overlay.size),
      items: [
        PopupMenuItem(
          value: _BookFilter.bonificable,
          child: Row(
            children: [
              Icon(Icons.circle, color: AppColor.primary),
              AppSpacing.widthSmall,
              const Expanded(child: Text('Bonificable')),
              if (_filter == _BookFilter.bonificable)
                const Icon(Icons.check_circle),
            ],
          ),
        ),
        PopupMenuItem(
          value: _BookFilter.noBonificable,
          child: Row(
            children: [
              Icon(Icons.circle, color: AppColor.error),
              AppSpacing.widthSmall,
              const Expanded(child: Text('No bonificable')),
              if (_filter == _BookFilter.noBonificable)
                const Icon(Icons.check_circle),
            ],
          ),
        ),
        PopupMenuItem(
          value: _BookFilter.inactive,
          child: Row(
            children: [
              Icon(Icons.circle, color: AppColor.gray),
              AppSpacing.widthSmall,
              const Expanded(child: Text('Desactivado')),
              if (_filter == _BookFilter.inactive)
                const Icon(Icons.check_circle),
            ],
          ),
        ),
      ],
    );

    if (selected != null) {
      setState(() => _filter = selected);
    }
  }

  Future<void> _showNameSortMenu(BuildContext context) async {
    final renderBox = context.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final rect = position & renderBox.size;

    final selected = await showMenu<_BookSort>(
      context: context,
      position: RelativeRect.fromRect(rect, Offset.zero & overlay.size),
      items: [
        PopupMenuItem(
          value: _BookSort.nameAscending,
          child: Row(
            children: [
              const Expanded(child: Text('Nombre: A-Z')),
              if (_sort == _BookSort.nameAscending)
                const Icon(Icons.check_circle),
            ],
          ),
        ),
        PopupMenuItem(
          value: _BookSort.nameDescending,
          child: Row(
            children: [
              const Expanded(child: Text('Nombre: Z-A')),
              if (_sort == _BookSort.nameDescending)
                const Icon(Icons.check_circle),
            ],
          ),
        ),
      ],
    );

    if (selected != null) {
      setState(() => _sort = selected);
    }
  }

  List<MaterialBook> _filteredBooks(List<MaterialBook> books) {
    final filtered = books.where((book) {
      final matchesSearch = book.name.toLowerCase().contains(
        _search.toLowerCase(),
      );
      final matchesFavorites = !_showFavorites || book.isFavorite;
      final matchesFilter = switch (_filter) {
        _BookFilter.all => true,
        _BookFilter.bonificable => book.status == bonificableStatus,
        _BookFilter.noBonificable => book.status == noBonificableStatus,
        _BookFilter.inactive => book.status == inactiveBookStatus,
      };
      return matchesSearch && matchesFilter && matchesFavorites;
    }).toList();

    filtered.sort(
      (a, b) => _sort == _BookSort.nameAscending
          ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
          : b.name.toLowerCase().compareTo(a.name.toLowerCase()),
    );
    return filtered;
  }
}

enum _BookFilter { all, bonificable, noBonificable, inactive }

enum _BookSort { nameAscending, nameDescending }

class _BookTile extends StatelessWidget {
  final MaterialBook book;
  final double imageHeight;
  final bool Function() onFavorite;

  const _BookTile({
    required this.book,
    required this.imageHeight,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return BookCardFormat(
      title: book.name,
      category: book.category.isEmpty ? 'Sin categoría' : book.category,
      categoryIsSecondary: book.category.isEmpty,
      categoryCrossAxisAlignment: CrossAxisAlignment.center,
      image: _BookCover(path: book.coverPath),
      imageHeight: imageHeight,
      onPressed: () => _showPreview(context),
      titleTrailing: _StatusBadge(status: book.status),
      leadingAction: IconButton(
        tooltip: 'Favorito',
        icon: _FavoriteIcon(isSelected: book.isFavorite),
        onPressed: () {
          onFavorite();
        },
      ),
      trailingAction: IconButton(
        tooltip: 'Ver',
        icon: AppIcon.visibility,
        onPressed: () => _openDetails(context),
      ),
      leadingActionAtBottom: true,
    );
  }

  void _openDetails(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => DetailBookScreen(book: book)));
  }

  Future<void> _showPreview(BuildContext context) async {
    var isFavorite = book.isFavorite;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setDialogState) => Dialog(
          child: Padding(
            padding: AppSpacing.paddingMedium,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 360,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _BookCover(path: book.coverPath),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: IconButton(
                          tooltip: 'Favorito',
                          icon: _FavoriteIcon(isSelected: isFavorite),
                          onPressed: () {
                            isFavorite = onFavorite();
                            setDialogState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.heightMedium,
                TextFormat.title(book.name),
                AppSpacing.heightMedium,
                ButtonFormat.primary(
                  label: 'Ver',
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _openDetails(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteIcon extends StatelessWidget {
  final bool isSelected;

  const _FavoriteIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final icon = isSelected ? AppIcon.marcadorSolid : AppIcon.marcador;
    return isSelected
        ? ColorFiltered(
            colorFilter: const ColorFilter.mode(
              AppColor.warning,
              BlendMode.srcIn,
            ),
            child: icon,
          )
        : icon;
  }
}

class _BookCover extends StatelessWidget {
  final String? path;

  const _BookCover({this.path});

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
              errorBuilder: (_, _, _) => _emptyCover(),
            )
          : _emptyCover(),
    );
  }

  Widget _emptyCover() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColor.gray.withOpacity(0.15),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
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

Color _getStatusColor(String status) {
  return switch (status) {
    bonificableStatus => AppColor.primary,
    noBonificableStatus => AppColor.error,
    inactiveBookStatus => AppColor.gray,
    _ => AppColor.warning,
  };
}
