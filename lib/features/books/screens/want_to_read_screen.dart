import 'package:flutter/material.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/shared/widgets/empty_state.dart';
import 'package:prac5/core/widgets/app_state_inherited_widget.dart';

class WantToReadScreen extends StatelessWidget {
  const WantToReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateInheritedWidget.of(context);

    if (appState == null) {
      return const Scaffold(
        body: Center(child: Text('Ошибка: AppState не найден')),
      );
    }

    final wantToReadBooks = appState.books.where((book) => !book.isRead).toList();

    final sortedBooks = wantToReadBooks.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

    return wantToReadBooks.isEmpty
        ? const EmptyState(
            icon: Icons.schedule_outlined,
            title: 'Список пуст',
            subtitle: 'Добавьте книги, которые хотите прочитать',
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
