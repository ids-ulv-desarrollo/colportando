import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/Materials/domain/entities/material_catalog.dart';
import 'package:colportando/features/Materials/presentation/riverpod/catalogs_riverpod.dart';
import 'package:colportando/features/Materials/presentation/riverpod/books_riverpod.dart';
import 'package:colportando/features/Materials/presentation/screens/books_screen.dart';
import 'package:colportando/features/Materials/presentation/screens/categories_screen.dart';
import 'package:colportando/features/Materials/presentation/screens/create_catalog_form.dart';
import 'package:colportando/features/Materials/presentation/screens/detail_catalog_form.dart';
import 'package:colportando/features/Materials/presentation/screens/resources_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaterialsScreen extends ConsumerWidget {
  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogs = ref.watch(catalogsProvider);
    final availableBooks = ref
        .watch(booksProvider)
        .map((book) => book.name)
        .toList();
    final activeCatalogs = catalogs
        .where((catalog) => catalog.status == activeCatalogStatus)
        .toList();
    final activeCatalog = activeCatalogs.isEmpty ? null : activeCatalogs.first;

    return ScaffoldFormat(
      titleAppBar: "Materiales",
      children: [
        ContainerFormat(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BooksScreen()),
          ),
          children: [
            Row(
              children: [
                AppIcon.libro,
                const SizedBox(width: 10),
                TextFormat.title("Libros"),
                const Spacer(),
                AppIcon.arrowRight,
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        ContainerFormat(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ResourcesScreen()),
          ),
          children: [
            Row(
              children: [
                AppIcon.file,
                const SizedBox(width: 10),
                TextFormat.title("Recursos"),
                const Spacer(),
                AppIcon.arrowRight,
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        ContainerFormat(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoriesScreen(availableBooks: availableBooks),
            ),
          ),
          children: [
            Row(
              children: [
                AppIcon.categoria,
                const SizedBox(width: 10),
                TextFormat.title("Categorías"),
                const Spacer(),
                AppIcon.arrowRight,
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(height: 40, child: TextFormat.title("Catálogos")),
        if (activeCatalog != null) ...[
          _CatalogTile(
            catalog: activeCatalog,
            onDetails: () =>
                _viewCatalog(context, activeCatalog, availableBooks),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Expanded(
              child: ButtonFormat.secondary(
                label: "Otros",
                onPressed: () => BottomSheetFormat.content(
                  _PreviousCatalogsSheet(availableBooks: availableBooks),
                  title: "Otros catálogos",
                ).show(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ButtonFormat.primary(
                label: "Crear",
                onPressed: () => BottomSheetFormat.content(
                  CreateCatalogForm(availableBooks: availableBooks),
                  title: "Nuevo catálogo",
                ).show(context),
              ),
            ),
          ],
        ),
        if (activeCatalog == null) ...[
          const SizedBox(height: 16),
          TextFormat.subtitle('Aún no hay un catálogo activo.'),
        ],
      ],
    );
  }

  void _viewCatalog(
    BuildContext context,
    MaterialCatalog catalog,
    List<String> availableBooks,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DetailCatalogForm(catalog: catalog, availableBooks: availableBooks),
      ),
    );
  }
}

class _CatalogTile extends StatelessWidget {
  final MaterialCatalog catalog;
  final VoidCallback onDetails;

  const _CatalogTile({required this.catalog, required this.onDetails});

  @override
  Widget build(BuildContext context) {
    return ContainerListTile(
      title: catalog.name,
      subtitle: catalog.description,
      subsubtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFormat.label('${catalog.bookCount} libros incluidos'),
          _StatusBadge(status: catalog.status),
        ],
      ),
      icon: AppIcon.catalogo,
      expandedChild: [
        Padding(
          padding: AppSpacing.paddingSymetric8_0,
          child: ButtonFormat.primary(
            label: 'Ver detalles',
            onPressed: onDetails,
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
    return Container(
      height: 20,
      width: 85,
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

class _PreviousCatalogsSheet extends ConsumerWidget {
  final List<String> availableBooks;

  const _PreviousCatalogsSheet({required this.availableBooks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previousCatalogs = ref
        .watch(catalogsProvider)
        .where((catalog) => catalog.status != activeCatalogStatus)
        .toList()
        .reversed
        .toList();

    return ListViewFormat(
      itemCount: previousCatalogs.length,
      emptyMessage: 'No hay otros catálogos.',
      itemBuilder: (context, index) {
        final catalog = previousCatalogs[index];
        return _CatalogTile(
          catalog: catalog,
          onDetails: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailCatalogForm(
                catalog: catalog,
                availableBooks: availableBooks,
              ),
            ),
          ),
        );
      },
    );
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
