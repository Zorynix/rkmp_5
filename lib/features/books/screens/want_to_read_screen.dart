import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/features/books/bloc/books_bloc.dart';
import 'package:prac5/features/books/bloc/books_event.dart';
import 'package:prac5/features/books/bloc/books_state.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class WantToReadScreen extends StatelessWidget {
  const WantToReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksState>(
      builder: (context, state) {
        if (state is! BooksLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final wantToReadBooks = state.wantToReadBooksList;

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
