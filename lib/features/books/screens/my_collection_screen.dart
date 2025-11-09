import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/features/books/bloc/books_bloc.dart';
import 'package:prac5/features/books/bloc/books_state.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class MyCollectionScreen extends StatelessWidget {
  const MyCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя коллекция'),
      ),
      body: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          if (state is BooksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! BooksLoaded) {
            return const Center(child: Text('Ошибка загрузки'));
          }

          final books = state.books;

          if (books.isEmpty) {
            return const EmptyState(
              icon: Icons.auto_stories,
              title: 'Коллекция пуста',
              subtitle: 'Добавьте книги в свою коллекцию',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookTile(
                key: ValueKey(book.id),
                book: book,
              );
            },
          );
        },
      ),
    );
  }
}

