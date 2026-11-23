import 'dart:io';

import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/filter_chip_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/Materials/domain/entities/material_book.dart';
import 'package:colportando/features/Materials/domain/entities/material_catalog.dart';
import 'package:colportando/features/Materials/presentation/riverpod/books_riverpod.dart';
import 'package:colportando/features/Materials/presentation/riverpod/catalogs_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailBookScreen extends ConsumerStatefulWidget {
  final MaterialBook book;

  const DetailBookScreen({super.key, required this.book});

  @override
  ConsumerState<DetailBookScreen> createState() => _DetailBookScreenState();
}

class _DetailBookScreenState extends ConsumerState<DetailBookScreen> {
  _ResourceFilter _resourceFilter = _ResourceFilter.all;

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final currentBook = ref
        .watch(booksProvider)
        .cast<MaterialBook?>()
        .firstWhere(
          (item) => item?.name == widget.book.name,
          orElse: () => widget.book,
        )!;
    final catalog = _findCatalog(ref.watch(catalogsProvider), currentBook);
    final imageResources = currentBook.resourcePaths
        .where(_isImagePath)
        .toList();
    final videoResources = currentBook.resourcePaths
        .where(_isVideoPath)
        .toList();
    final documentResources = currentBook.resourcePaths
        .where(_isDocumentPath)
        .toList();
    final showImages =
        _resourceFilter == _ResourceFilter.all ||
        _resourceFilter == _ResourceFilter.images;
    final showVideos =
        _resourceFilter == _ResourceFilter.all ||
        _resourceFilter == _ResourceFilter.videos;
    final showDocuments =
        _resourceFilter == _ResourceFilter.all ||
        _resourceFilter == _ResourceFilter.documents;
    final filteredImages = showImages ? imageResources : <String>[];
    final filteredVideos = showVideos ? videoResources : <String>[];
    final filteredDocuments = showDocuments ? documentResources : <String>[];

    return ScaffoldFormat(
      titleAppBar: 'Detalle del libro',
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: TextFormat.title(currentBook.name)),
                    ],
                  ),
                  AppSpacing.heightSmall,
                  TextFormat.bodySecondary(
                    TextFormat.descriptionPreview(currentBook.description),
                  ),
                ],
              ),
            ),
            AppSpacing.widthMedium,
            Expanded(
              child: _CoverImage(
                path: currentBook.coverPath,
                status: currentBook.status,
                isFavorite: currentBook.isFavorite,
                onFavorite: () => _toggleFavorite(context, ref, currentBook),
                onTap: () => _showImagePreview(context, currentBook.coverPath),
              ),
            ),
          ],
        ),
        AppSpacing.heightMedium,
        TextFormat.subtitle('Categoría'),
        AppSpacing.heightSmall,
        Row(
          children: [
            AppIcon.categoria,
            AppSpacing.widthSmall,
            Expanded(
              child: TextFormat.bodySecondary(
                currentBook.category.isEmpty
                    ? 'Sin categoría'
                    : currentBook.category,
              ),
            ),
          ],
        ),
        AppSpacing.heightMedium,
        TextFormat.subtitle('Catálogo'),
        AppSpacing.heightSmall,
        TextFormat.bodySecondary(catalog?.name ?? 'Sin catálogo'),
        AppSpacing.heightMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormat.subtitle('Recursos'),
            Builder(
              builder: (filterContext) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showResourceFilter(filterContext),
                child: FilterChipFormat(
                  label: switch (_resourceFilter) {
                    _ResourceFilter.all => 'Todos',
                    _ResourceFilter.images => 'Imágenes',
                    _ResourceFilter.videos => 'Videos',
                    _ResourceFilter.documents => 'Documentos',
                  },
                  isSelected: true,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.heightSmall,
        if (filteredImages.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              const sidePeek = 54.0;
              final itemWidth = constraints.maxWidth - sidePeek;
              return SizedBox(
                height: itemWidth,
                child: PageView.builder(
                  padEnds: true,
                  controller: PageController(
                    viewportFraction: itemWidth / constraints.maxWidth,
                  ),
                  itemCount: filteredImages.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: _ResourceImage(
                      path: filteredImages[index],
                      onTap: () =>
                          _showImagePreview(context, filteredImages[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        if (filteredVideos.isNotEmpty) ...[
          if (filteredImages.isNotEmpty) AppSpacing.heightMedium,
          TextFormat.subtitle('Videos'),
          AppSpacing.heightSmall,
          for (final resource in filteredVideos)
            TextFormat.bodySecondary(_fileName(resource)),
        ],
        if (filteredDocuments.isNotEmpty) ...[
          if (filteredImages.isNotEmpty || filteredVideos.isNotEmpty)
            AppSpacing.heightMedium,
          TextFormat.subtitle('Documentos'),
          AppSpacing.heightSmall,
          for (final resource in filteredDocuments)
            TextFormat.bodySecondary(_fileName(resource)),
        ],
        if (filteredImages.isEmpty &&
            filteredVideos.isEmpty &&
            filteredDocuments.isEmpty)
          TextFormat.bodySecondary('No hay recursos en esta categoría.'),
      ],
    );
  }

  void _toggleFavorite(
    BuildContext context,
    WidgetRef ref,
    MaterialBook currentBook,
  ) {
    final isFavorite = ref
        .read(booksProvider.notifier)
        .toggleFavorite(currentBook);
    SnackBarFormat().show(
      context,
      isFavorite
          ? 'Libro agregado a favoritos'
          : 'Libro eliminado de favoritos',
    );
  }

  MaterialCatalog? _findCatalog(
    List<MaterialCatalog> catalogs,
    MaterialBook currentBook,
  ) {
    for (final catalog in catalogs) {
      if (catalog.bookIds.contains(currentBook.name)) return catalog;
    }
    return null;
  }

  bool _isImagePath(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  bool _isVideoPath(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(extension);
  }

  bool _isDocumentPath(String path) {
    final extension = path.split('.').last.toLowerCase();
    return extension == 'pdf';
  }

  String _fileName(String path) {
    return path.split(Platform.pathSeparator).last;
  }

  Future<void> _showResourceFilter(BuildContext context) async {
    final renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final rect = position & renderBox.size;

    final selected = await showMenu<_ResourceFilter>(
      context: context,
      position: RelativeRect.fromRect(rect, Offset.zero & overlay.size),
      items: [
        const PopupMenuItem(value: _ResourceFilter.all, child: Text('Todos')),
        const PopupMenuItem(
          value: _ResourceFilter.images,
          child: Text('Imágenes'),
        ),
        const PopupMenuItem(
          value: _ResourceFilter.videos,
          child: Text('Videos'),
        ),
        const PopupMenuItem(
          value: _ResourceFilter.documents,
          child: Text('Documentos'),
        ),
      ],
    );

    if (selected != null) {
      setState(() => _resourceFilter = selected);
    }
  }

  Future<void> _showImagePreview(BuildContext context, String? path) async {
    if (path == null || path.isEmpty) return;
    await showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700, maxHeight: 700),
            child: Image.file(
              File(path),
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  TextFormat.bodySecondary('No se pudo mostrar la imagen.'),
            ),
          ),
        ),
      ),
    );
  }
}

enum _ResourceFilter { all, images, videos, documents }

class _CoverImage extends StatelessWidget {
  final String? path;
  final String status;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const _CoverImage({
    required this.path,
    required this.status,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return AspectRatio(
      aspectRatio: 0.7,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 4),
          borderRadius: AppSpacing.borderSmall,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: ClipRRect(
                borderRadius: AppSpacing.borderSmall,
                child: path == null
                    ? const SizedBox.expand()
                    : Image.file(
                        File(path!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.expand(),
                      ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: IconButton(
                tooltip: 'Favorito',
                icon: _FavoriteIcon(isSelected: isFavorite),
                onPressed: onFavorite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceImage extends StatelessWidget {
  final String path;
  final VoidCallback onTap;

  const _ResourceImage({required this.path, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: AppSpacing.borderSmall,
        child: Image.file(
          File(path),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              TextFormat.bodySecondary('No se pudo mostrar el recurso.'),
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

Color _getStatusColor(String status) {
  return switch (status) {
    bonificableStatus => AppColor.primary,
    noBonificableStatus => AppColor.error,
    inactiveBookStatus => AppColor.gray,
    _ => AppColor.warning,
  };
}
