import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/features/books/screens/book_form_screen.dart';
import 'package:prac5/features/books/bloc/books_bloc.dart';
import 'package:prac5/features/books/bloc/books_event.dart';
import 'package:prac5/features/books/bloc/books_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddBookDialog(BuildContext context) {
    context.push('/book-form', extra: {
      'onSave': (book) {
        context.read<BooksBloc>().add(AddBook(book));
        context.pop();
      },
    });
  }

  void _openProfile(BuildContext context) {
    context.push('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          if (state is BooksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BooksError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(state.message, style: theme.textTheme.titleMedium),
                ],
              ),
            );
          }

          if (state is! BooksLoaded) {
            return const Center(child: Text('Неизвестное состояние'));
          }

          final totalBooks = state.totalBooks;
          final readBooks = state.readBooks;
          final wantToRead = state.wantToReadBooks;
          final averageRating = state.averageRating;
          final recentBooks = state.recentBooks;

          return CustomScrollView(
            slivers: [
              SliverAppBar.large(
                floating: true,
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Список книг',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primaryContainer,
                          colorScheme.secondaryContainer,
                        ],
                      ),
                    ),
                  ),
                  centerTitle: true,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: const Icon(Icons.person_outline),
                        onPressed: () => _openProfile(context),
                        tooltip: 'Профиль',
                      ),
                    ),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_stories,
                                  color: colorScheme.onPrimary,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Моя коллекция',
                                        style: TextStyle(
                                          color: colorScheme.onPrimary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '$totalBooks ${_getBooksWord(totalBooks)}',
                                        style: TextStyle(
                                          color: colorScheme.onPrimary.withValues(alpha: 0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _showAddBookDialog(context),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colorScheme.onPrimary.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'Статистика',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.push('/read-books'),
                              child: _buildStatCard(
                                context: context,
                                icon: Icons.check_circle_outline,
                                value: readBooks.toString(),
                                label: 'Прочитано',
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.push('/want-to-read'),
                              child: _buildStatCard(
                                context: context,
                                icon: Icons.schedule_outlined,
                                value: wantToRead.toString(),
                                label: 'В планах',
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context: context,
                              icon: Icons.star_outline,
                              value: averageRating.toStringAsFixed(1),
                              label: 'Средняя оценка',
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              context: context,
                              icon: Icons.trending_up,
                              value: '${(totalBooks > 0 ? (readBooks / totalBooks * 100) : 0).toStringAsFixed(0)}%',
                              label: 'Прогресс',
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Недавно добавленные',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (state.books.length > 5)
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_forward, size: 18),
                              label: const Text('Все'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              if (recentBooks.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 80,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Книг пока нет',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Добавьте первую книгу в коллекцию',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.outline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final book = recentBooks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: BookTile(
                            key: ValueKey(book.id),
                            book: book,
                          ),
                        );
                      },
                      childCount: recentBooks.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  String _getBooksWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'книга';
    } else if ([2, 3, 4].contains(count % 10) && ![12, 13, 14].contains(count % 100)) {
      return 'книги';
    } else {
      return 'книг';
    }
  }
}

