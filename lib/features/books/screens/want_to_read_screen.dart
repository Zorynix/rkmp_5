import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class WantToReadScreen extends StatelessWidget {
  final List<Book> books;
  final Function(String) onDeleteBook;
  final Function(String, bool) onToggleRead;
  final Function(String, int) onRateBook;
  final Function(Book) onUpdateBook;

  const WantToReadScreen({
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
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

    return books.isEmpty
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
                onDelete: () => onDeleteBook(book.id),
                onToggleRead: (isRead) => onToggleRead(book.id, isRead),
                onRate: (rating) => onRateBook(book.id, rating),
                onUpdate: onUpdateBook,
              );
            },
          );
  }
}
