import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/statistics_card.dart';
import '../widgets/book_tile.dart';
import 'book_form_screen.dart';
import 'all_books_screen.dart';
import 'read_books_screen.dart';
import 'want_to_read_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Book> books;
  final Function(Book) onAddBook;
  final Function(String) onDeleteBook;
  final Function(String, bool) onToggleRead;
  final Function(String, int) onRateBook;

  const HomeScreen({
    super.key,
    required this.books,
    required this.onAddBook,
    required this.onDeleteBook,
    required this.onToggleRead,
    required this.onRateBook,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return AllBooksScreen(
          books: widget.books,
          onDeleteBook: widget.onDeleteBook,
          onToggleRead: widget.onToggleRead,
          onRateBook: widget.onRateBook,
        );
      case 2:
        return ReadBooksScreen(
          books: widget.books.where((book) => book.isRead).toList(),
          onDeleteBook: widget.onDeleteBook,
          onToggleRead: widget.onToggleRead,
          onRateBook: widget.onRateBook,
        );
      case 3:
        return WantToReadScreen(
          books: widget.books.where((book) => !book.isRead).toList(),
          onDeleteBook: widget.onDeleteBook,
          onToggleRead: widget.onToggleRead,
          onRateBook: widget.onRateBook,
        );
      default:
        return _buildHomeTab();
    }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Недавно добавленные',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.books.length > 5)
                TextButton(
                  onPressed: () => _onItemTapped(1),
                  child: const Text('Все книги'),
                ),
            ],
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
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Библиотека книг'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _getSelectedScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Все книги',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Прочитано',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Хочу прочитать',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        tooltip: 'Добавить книгу',
        child: const Icon(Icons.add),
      ),
    );
  }
}

