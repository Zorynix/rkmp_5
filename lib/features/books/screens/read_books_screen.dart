import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class ReadBooksScreen extends StatelessWidget {
  final List<Book> books;
  final Function(String) onDeleteBook;
  final Function(String, bool) onToggleRead;
  final Function(String, int) onRateBook;
  final Function(Book) onUpdateBook;

  const ReadBooksScreen({
    super.key,
    required this.books,
    required this.onDeleteBook,
    required this.onToggleRead,
    required this.onRateBook,
    required this.onUpdateBook,
  });

  @override
  Widget build(BuildContext context) {
    final sortedBooks = books.toList()
      ..sort((a, b) {
        if (a.dateFinished == null && b.dateFinished == null) return 0;
        if (a.dateFinished == null) return 1;
        if (b.dateFinished == null) return -1;
        return b.dateFinished!.compareTo(a.dateFinished!);
      });

    return books.isEmpty
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
                onDelete: () => onDeleteBook(book.id),
                onToggleRead: (isRead) => onToggleRead(book.id, isRead),
                onRate: (rating) => onRateBook(book.id, rating),
                onUpdate: onUpdateBook,
              );
            },
          );
  }
}
