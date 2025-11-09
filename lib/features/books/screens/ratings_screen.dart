import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/features/books/bloc/books_bloc.dart';
import 'package:prac5/features/books/bloc/books_state.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class RatingsScreen extends StatelessWidget {
  const RatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оценки'),
      ),
      body: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          if (state is BooksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! BooksLoaded) {
            return const Center(child: Text('Ошибка загрузки'));
          }

          final ratedBooks = state.books
              .where((book) => book.rating != null)
              .toList()
            ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

          if (ratedBooks.isEmpty) {
            return const EmptyState(
              icon: Icons.star_outline,
              title: 'Нет оценок',
              subtitle: 'Оцените прочитанные книги',
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Средняя оценка',
                      state.averageRating.toStringAsFixed(1),
                      Icons.star,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.amber.withValues(alpha: 0.3),
                    ),
                    _buildStatItem(
                      'Оценено книг',
                      ratedBooks.length.toString(),
                      Icons.check_circle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: ratedBooks.length,
                  itemBuilder: (context, index) {
                    final book = ratedBooks[index];
                    return BookTile(
                      key: ValueKey(book.id),
                      book: book,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

