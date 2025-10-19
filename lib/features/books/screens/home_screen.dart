import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/features/books/widgets/statistics_card.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/features/books/screens/book_form_screen.dart';
import 'package:prac5/features/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onAddBook;
  final Function(String) onDeleteBook;
  final Function(String, bool) onToggleRead;
  final Function(String, int) onRateBook;
  final Function(Book) onUpdateBook;

  const HomeScreen({
    super.key,
    required this.books,
    required this.onAddBook,
    required this.onDeleteBook,
    required this.onToggleRead,
    required this.onRateBook,
    required this.onUpdateBook,
  });

  void _showAddBookDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookFormScreen(
          onSave: (book) {
            onAddBook(book);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalBooks = books.length;
    final readBooks = books.where((book) => book.isRead).length;
    final wantToRead = totalBooks - readBooks;
    final averageRating = books.where((book) => book.rating != null).isEmpty
        ? 0.0
        : books
                .where((book) => book.rating != null)
                .map((book) => book.rating!)
                .reduce((a, b) => a + b) /
            books.where((book) => book.rating != null).length;

    final recentBooks = books.isEmpty
        ? <Book>[]
        : (books.toList()..sort((a, b) => b.dateAdded.compareTo(a.dateAdded)))
            .take(5)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список книг'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _openProfile(context),
            tooltip: 'Профиль',
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    onDelete: () => onDeleteBook(book.id),
                    onToggleRead: (isRead) => onToggleRead(book.id, isRead),
                    onRate: (rating) => onRateBook(book.id, rating),
                    onUpdate: onUpdateBook,
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBookDialog(context),
        tooltip: 'Добавить книгу',
        child: const Icon(Icons.add),
      ),
    );
  }
}
