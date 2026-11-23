import 'package:colportando/features/Materials/domain/entities/material_book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BooksNotifier extends Notifier<List<MaterialBook>> {
  @override
  List<MaterialBook> build() => const [];

  MaterialBook? createBook({
    required String name,
    required String description,
    required String category,
    String? coverPath,
    List<String> resourcePaths = const [],
    bool isBonus = false,
  }) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty ||
        state.any(
          (book) => book.name.toLowerCase() == trimmedName.toLowerCase(),
        )) {
      return null;
    }

    final book = MaterialBook(
      name: trimmedName,
      description: description.trim(),
      category: category.trim(),
      coverPath: coverPath,
      resourcePaths: List.unmodifiable(resourcePaths),
      isBonus: isBonus,
      createdAt: DateTime.now(),
    );
    state = [...state, book];
    return book;
  }

  bool toggleFavorite(MaterialBook target) {
    final index = state.indexWhere((book) => identical(book, target));
    if (index == -1) return false;

    state = [
      for (var currentIndex = 0; currentIndex < state.length; currentIndex++)
        currentIndex == index
            ? state[currentIndex].copyWith(
                isFavorite: !state[currentIndex].isFavorite,
              )
            : state[currentIndex],
    ];
    return state[index].isFavorite;
  }

  bool assignCategory({required String bookName, required String category}) {
    final index = state.indexWhere((book) => book.name == bookName);
    if (index == -1) return false;

    state = [
      for (var currentIndex = 0; currentIndex < state.length; currentIndex++)
        currentIndex == index
            ? state[currentIndex].copyWith(category: category)
            : state[currentIndex],
    ];
    return true;
  }
}

final booksProvider = NotifierProvider<BooksNotifier, List<MaterialBook>>(
  BooksNotifier.new,
);
