import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/features/books/screens/book_form_screen.dart';
import 'package:prac5/features/books/widgets/statistics_card.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';

class RouteNavigation extends StatefulWidget {
  final List<Book> books;
  final Function(Book) onAddBook;
  final Function(String) onDeleteBook;
  final Function(String, bool) onToggleRead;
  final Function(String, int) onRateBook;
  final Function(Book) onUpdateBook;

  const RouteNavigation({
    super.key,
    required this.books,
    required this.onAddBook,
    required this.onDeleteBook,
    required this.onToggleRead,
    required this.onRateBook,
    required this.onUpdateBook,
  });

  @override
  State<RouteNavigation> createState() => _RouteNavigationState();
}

class _RouteNavigationState extends State<RouteNavigation> {
  void _showAddBookDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookFormScreen(
          onSave: (book) {
            widget.onAddBook(book);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    final totalBooks = widget.books.length;
    final readBooks = widget.books.where((book) => book.isRead).length;
    final wantToRead = totalBooks - readBooks;
    final averageRating = widget.books.where((book) => book.rating != null).isEmpty
        ? 0.0
        : widget.books
                .where((book) => book.rating != null)
                .map((book) => book.rating!)
                .reduce((a, b) => a + b) /
            widget.books.where((book) => book.rating != null).length;

    final recentBooks = widget.books.isEmpty
        ? <Book>[]
        : (widget.books.toList()
          ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded)))
            .take(5)
            .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Статистика',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              StatisticsCard(
                title: 'Всего книг',
                value: totalBooks.toString(),
                icon: Icons.menu_book,
                color: Colors.indigo,
              ),
              StatisticsCard(
                title: 'Прочитано',
                value: readBooks.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              StatisticsCard(
                title: 'Хочу прочитать',
                value: wantToRead.toString(),
                icon: Icons.schedule,
                color: Colors.orange,
              ),
              StatisticsCard(
                title: 'Средняя оценка',
                value: averageRating.toStringAsFixed(1),
                icon: Icons.star,
                color: Colors.amber,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Недавно добавленные',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (recentBooks.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Книг пока нет\nДобавьте первую книгу',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentBooks.length,
              itemBuilder: (context, index) {
                final book = recentBooks[index];
                return BookTile(
                  key: ValueKey(book.id),
                  book: book,
                  onDelete: () => widget.onDeleteBook(book.id),
                  onToggleRead: (isRead) => widget.onToggleRead(book.id, isRead),
                  onRate: (rating) => widget.onRateBook(book.id, rating),
                  onUpdate: widget.onUpdateBook,
                );
              },
            ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Навигация через Routes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildNavigationCard(
            icon: Icons.menu_book,
            title: 'Все книги',
            subtitle: 'Просмотр всех книг с фильтрацией',
            color: Colors.indigo,
            onTap: () => Navigator.pushNamed(context, '/all-books'),
          ),
          const SizedBox(height: 12),
          _buildNavigationCard(
            icon: Icons.check_circle,
            title: 'Прочитанные книги',
            subtitle: 'Книги, которые вы уже прочитали',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Прочитанные книги'),
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, size: 80, color: Colors.green),
                          const SizedBox(height: 24),
                          const Text(
                            'Экран с прочитанными книгами',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Вернуться назад (pop)'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildNavigationCard(
            icon: Icons.schedule,
            title: 'Хочу прочитать',
            subtitle: 'Список книг для чтения',
            color: Colors.orange,
            onTap: () => Navigator.pushNamed(context, '/want-to-read'),
          ),
          const SizedBox(height: 12),
          _buildNavigationCard(
            icon: Icons.person,
            title: 'Профиль',
            subtitle: 'Настройки и информация о пользователе',
            color: Colors.blue,
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная (Route Navigation)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Маршрутизированная навигация'),
                  content: const Text(
                    'Нажимайте на карточки для перехода между экранами.\n\n'
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _buildHomeTab(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        tooltip: 'Добавить книгу',
        child: const Icon(Icons.add),
      ),
    );
  }
}
