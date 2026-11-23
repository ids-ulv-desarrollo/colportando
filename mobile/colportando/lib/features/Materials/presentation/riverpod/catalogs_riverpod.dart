import 'package:colportando/features/Materials/domain/entities/material_catalog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalogsNotifier extends Notifier<List<MaterialCatalog>> {
  @override
  List<MaterialCatalog> build() => const [];

  bool createCatalog({
    required String name,
    required String description,
    required String campaign,
    required String status,
    required List<String> bookIds,
    required List<String> categoryIds,
  }) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty ||
        state.any(
          (catalog) => catalog.name.toLowerCase() == trimmedName.toLowerCase(),
        )) {
      return false;
    }
    _appendCatalog(
      name: trimmedName,
      description: description,
      campaign: campaign,
      status: status,
      bookIds: bookIds,
      categoryIds: categoryIds,
    );
    return true;
  }

  bool updateCatalog({
    required MaterialCatalog originalCatalog,
    required String name,
    required String description,
    required List<String> bookIds,
    required List<String> categoryIds,
  }) {
    final trimmedName = name.trim();
    final index = state.indexWhere(
      (catalog) => identical(catalog, originalCatalog),
    );
    if (trimmedName.isEmpty ||
        index == -1 ||
        state[index].status != activeCatalogStatus ||
        state.any(
          (catalog) =>
              catalog.name.toLowerCase() == trimmedName.toLowerCase() &&
              !identical(catalog, originalCatalog),
        )) {
      return false;
    }

    state = [
      for (var currentIndex = 0; currentIndex < state.length; currentIndex++)
        if (currentIndex == index)
          MaterialCatalog(
            name: trimmedName,
            description: description.trim(),
            campaign: state[currentIndex].campaign,
            status: state[currentIndex].status,
            bookIds: List.unmodifiable(bookIds),
            categoryIds: List.unmodifiable(categoryIds),
            createdAt: state[currentIndex].createdAt,
          )
        else
          state[currentIndex],
    ];
    return true;
  }

  bool createCatalogVersion({
    required String name,
    required String description,
    required String campaign,
    required List<String> bookIds,
    required List<String> categoryIds,
  }) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return false;

    _appendCatalog(
      name: trimmedName,
      description: description,
      campaign: campaign,
      status: activeCatalogStatus,
      bookIds: bookIds,
      categoryIds: categoryIds,
    );
    return true;
  }

  bool closeCatalog(MaterialCatalog target) {
    final index = state.indexWhere((catalog) => identical(catalog, target));
    if (index == -1 || state[index].status != activeCatalogStatus) {
      return false;
    }

    state = [
      for (var currentIndex = 0; currentIndex < state.length; currentIndex++)
        if (currentIndex == index)
          MaterialCatalog(
            name: state[currentIndex].name,
            description: state[currentIndex].description,
            campaign: state[currentIndex].campaign,
            status: closedCatalogStatus,
            bookIds: state[currentIndex].bookIds,
            categoryIds: state[currentIndex].categoryIds,
            createdAt: state[currentIndex].createdAt,
          )
        else
          state[currentIndex],
    ];
    return true;
  }

  bool deleteCatalog(MaterialCatalog target) {
    final exists = state.any((catalog) => identical(catalog, target));
    if (!exists) return false;

    state = [
      for (final catalog in state)
        if (!identical(catalog, target)) catalog,
    ];
    return true;
  }

  void _appendCatalog({
    required String name,
    required String description,
    required String campaign,
    required String status,
    required List<String> bookIds,
    required List<String> categoryIds,
  }) {
    state = [
      ...state,
      MaterialCatalog(
        name: name,
        description: description.trim(),
        campaign: campaign,
        status: status,
        bookIds: List.unmodifiable(bookIds),
        categoryIds: List.unmodifiable(categoryIds),
        createdAt: DateTime.now(),
      ),
    ];
  }
}

final catalogsProvider =
    NotifierProvider<CatalogsNotifier, List<MaterialCatalog>>(
      CatalogsNotifier.new,
    );
