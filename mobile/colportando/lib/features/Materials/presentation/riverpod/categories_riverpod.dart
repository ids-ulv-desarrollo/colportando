import 'package:colportando/features/Materials/domain/entities/material_category.dart';
import 'package:colportando/features/Materials/presentation/riverpod/books_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesNotifier extends Notifier<List<MaterialCategory>> {
  @override
  List<MaterialCategory> build() => const [];

  bool createCategory({
    required String name,
    required String description,
    required List<String> bookIds,
  }) {
    final trimmedName = name.trim();
    final uniqueBookIds = {...bookIds}.toList();
    if (trimmedName.isEmpty ||
        uniqueBookIds.isEmpty ||
        state.any(
          (category) =>
              category.name.toLowerCase() == trimmedName.toLowerCase(),
        )) {
      return false;
    }

    state = [
      ...state,
      MaterialCategory(
        name: trimmedName,
        description: description.trim(),
        bookIds: List.unmodifiable(uniqueBookIds),
        status: activeCategoryStatus,
        createdAt: DateTime.now(),
      ),
    ];
    _assignCategoryToBooks(trimmedName, uniqueBookIds);
    return true;
  }

  bool updateCategory({
    required MaterialCategory originalCategory,
    required String name,
    required String description,
    required List<String> bookIds,
  }) {
    final trimmedName = name.trim();
    final uniqueBookIds = {...bookIds}.toList();
    final index = state.indexWhere(
      (category) => identical(category, originalCategory),
    );
    if (trimmedName.isEmpty ||
        uniqueBookIds.isEmpty ||
        index == -1 ||
        state.any(
          (category) =>
              category.name.toLowerCase() == trimmedName.toLowerCase() &&
              !identical(category, originalCategory),
        )) {
      return false;
    }

    state = [
      for (var currentIndex = 0; currentIndex < state.length; currentIndex++)
        if (currentIndex == index)
          MaterialCategory(
            name: trimmedName,
            description: description.trim(),
            bookIds: List.unmodifiable(uniqueBookIds),
            status: state[currentIndex].status,
            createdAt: state[currentIndex].createdAt,
          )
        else
          state[currentIndex],
    ];
    final removedBookIds = originalCategory.bookIds
        .where((bookId) => !uniqueBookIds.contains(bookId))
        .toList();
    _assignCategoryToBooks(trimmedName, uniqueBookIds);
    _clearCategoryFromBooks(removedBookIds, originalCategory.name);
    return true;
  }

  bool deactivateCategory(MaterialCategory target) {
    final index = state.indexWhere((category) => identical(category, target));
    if (index == -1 || state[index].status == inactiveCategoryStatus) {
      return false;
    }

    state = [
      for (var currentIndex = 0; currentIndex < state.length; currentIndex++)
        if (currentIndex == index)
          MaterialCategory(
            name: state[currentIndex].name,
            description: state[currentIndex].description,
            bookIds: state[currentIndex].bookIds,
            status: inactiveCategoryStatus,
            createdAt: state[currentIndex].createdAt,
          )
        else
          state[currentIndex],
    ];
    return true;
  }

  bool toggleCategoryStatus(MaterialCategory target) {
    final index = state.indexWhere((category) => identical(category, target));
    if (index == -1) return false;

    final nextStatus = state[index].status == activeCategoryStatus
        ? inactiveCategoryStatus
        : activeCategoryStatus;
    state = [
      for (var currentIndex = 0; currentIndex < state.length; currentIndex++)
        if (currentIndex == index)
          MaterialCategory(
            name: state[currentIndex].name,
            description: state[currentIndex].description,
            bookIds: state[currentIndex].bookIds,
            status: nextStatus,
            createdAt: state[currentIndex].createdAt,
          )
        else
          state[currentIndex],
    ];
    return true;
  }

  bool deleteCategory(MaterialCategory target) {
    if (!state.any((category) => identical(category, target))) return false;
    state = [
      for (final category in state)
        if (!identical(category, target)) category,
    ];
    _clearCategoryFromBooks(target.bookIds, target.name);
    return true;
  }

  void _assignCategoryToBooks(String categoryName, List<String> bookIds) {
    final booksNotifier = ref.read(booksProvider.notifier);
    state = [
      for (final category in state)
        if (category.name == categoryName)
          category
        else
          MaterialCategory(
            name: category.name,
            description: category.description,
            bookIds: List.unmodifiable(
              category.bookIds
                  .where((bookId) => !bookIds.contains(bookId))
                  .toList(),
            ),
            status: category.status,
            createdAt: category.createdAt,
          ),
    ];
    for (final bookId in bookIds) {
      booksNotifier.assignCategory(bookName: bookId, category: categoryName);
    }
  }

  void _clearCategoryFromBooks(List<String> bookIds, String categoryName) {
    final books = ref.read(booksProvider);
    final booksNotifier = ref.read(booksProvider.notifier);
    for (final bookId in bookIds) {
      final index = books.indexWhere((item) => item.name == bookId);
      if (index != -1 && books[index].category == categoryName) {
        booksNotifier.assignCategory(bookName: bookId, category: '');
      }
    }
  }
}

final categoriesProvider =
    NotifierProvider<CategoriesNotifier, List<MaterialCategory>>(
      CategoriesNotifier.new,
    );
