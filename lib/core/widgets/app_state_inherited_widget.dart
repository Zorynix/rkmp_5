import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/services/theme_service.dart';

class AppStateInheritedWidget extends InheritedWidget {
  final List<Book> books;
  final Function(Book) onAddBook;
  final Function(String) onDeleteBook;
  final Function(String, bool) onToggleRead;
  final Function(String, int) onRateBook;
  final Function(Book) onUpdateBook;
  final ThemeService themeService;

  const AppStateInheritedWidget({
    super.key,
    required this.books,
    required this.onAddBook,
    required this.onDeleteBook,
    required this.onToggleRead,
    required this.onRateBook,
    required this.onUpdateBook,
    required this.themeService,
    required super.child,
  });


  static AppStateInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateInheritedWidget>();
  }

  static AppStateInheritedWidget? read(BuildContext context) {
    return context.getInheritedWidgetOfExactType<AppStateInheritedWidget>();
  }

  @override
  bool updateShouldNotify(AppStateInheritedWidget oldWidget) {
    return books != oldWidget.books || themeService != oldWidget.themeService;
  }

  int get totalBooks => books.length;

  int get readBooks => books.where((book) => book.isRead).length;

  int get wantToReadBooks => totalBooks - readBooks;

  double get averageRating {
    final ratedBooks = books.where((book) => book.rating != null);
    if (ratedBooks.isEmpty) return 0.0;

    final sum = ratedBooks.map((book) => book.rating!).reduce((a, b) => a + b);
    return sum / ratedBooks.length;
  }

  List<Book> get recentBooks {
    if (books.isEmpty) return [];

    final sorted = books.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return sorted.take(5).toList();
  }
}

