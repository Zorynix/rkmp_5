import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/features/books/bloc/books_bloc.dart';
import 'package:prac5/features/books/bloc/books_event.dart';
import 'package:prac5/features/books/bloc/books_state.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class ReadBooksScreen extends StatelessWidget {
  const ReadBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksState>(
      builder: (context, state) {
        if (state is! BooksLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final readBooks = state.readBooksList;

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
                    onDelete: () => context.read<BooksBloc>().add(DeleteBook(book.id)),
                    onToggleRead: (isRead) => context.read<BooksBloc>().add(ToggleBookRead(book.id, isRead)),
                    onRate: (rating) => context.read<BooksBloc>().add(RateBook(book.id, rating)),
                    onUpdate: (book) => context.read<BooksBloc>().add(UpdateBook(book)),
                  );
                },
              );
      },
    );
  }
}
