import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/books/bloc/books_bloc.dart';
import 'package:prac5/features/books/bloc/books_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          if (state is BooksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! BooksLoaded) {
            return const Center(child: Text('Ошибка загрузки'));
          }

          final totalBooks = state.totalBooks;
          final readBooks = state.readBooks;
          final wantToRead = state.wantToReadBooks;
          final averageRating = state.averageRating;
          final progress = totalBooks > 0 ? (readBooks / totalBooks * 100) : 0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatCard(
                title: 'Общая статистика',
                icon: Icons.library_books,
                color: Colors.blue,
                children: [
                  _buildStatRow('Всего книг', totalBooks.toString()),
                  _buildStatRow('Прочитано', readBooks.toString()),
                  _buildStatRow('В планах', wantToRead.toString()),
                  _buildStatRow('Прогресс', '${progress.toStringAsFixed(0)}%'),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Оценки',
                icon: Icons.star,
                color: Colors.amber,
                children: [
                  _buildStatRow(
                    'Средняя оценка',
                    averageRating.toStringAsFixed(1),
                  ),
                  _buildStatRow(
                    'Оценено книг',
                    state.books.where((b) => b.rating != null).length.toString(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'По жанрам',
                icon: Icons.category,
                color: Colors.green,
                children: _buildGenreStats(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGenreStats(BooksLoaded state) {
    final genreMap = <String, int>{};
    for (var book in state.books) {
      genreMap[book.genre] = (genreMap[book.genre] ?? 0) + 1;
    }

    final sortedGenres = genreMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sortedGenres.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Нет данных',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ];
    }

    return sortedGenres
        .map((entry) => _buildStatRow(entry.key, entry.value.toString()))
        .toList();
  }
}

