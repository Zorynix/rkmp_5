import 'package:flutter/material.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/shared/widgets/empty_state.dart';
import 'package:prac5/core/widgets/app_state_inherited_widget.dart';

class ReadBooksScreen extends StatelessWidget {
  const ReadBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateInheritedWidget.of(context);

    if (appState == null) {
      return const Scaffold(
        body: Center(child: Text('Ошибка: AppState не найден')),
      );
    }

    final readBooks = appState.books.where((book) => book.isRead).toList();

    final sortedBooks = readBooks.toList()
      ..sort((a, b) {
        if (a.dateFinished == null && b.dateFinished == null) return 0;
        if (a.dateFinished == null) return 1;
        if (b.dateFinished == null) return -1;
        return b.dateFinished!.compareTo(a.dateFinished!);
      });

    return readBooks.isEmpty
        ? const EmptyState(
            icon: Icons.check_circle_outline,
            title: 'Нет прочитанных книг',
            subtitle: 'Отметьте книги как прочитанные',
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: sortedBooks.length,
            itemBuilder: (context, index) {
              final book = sortedBooks[index];
              return BookTile(
                key: ValueKey(book.id),
                book: book,
                onDelete: () => appState.onDeleteBook(book.id),
                onToggleRead: (isRead) => appState.onToggleRead(book.id, isRead),
                onRate: (rating) => appState.onRateBook(book.id, rating),
                onUpdate: appState.onUpdateBook,
              );
            },
          );
  }
}
