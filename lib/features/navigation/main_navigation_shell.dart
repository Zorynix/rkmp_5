import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/features/books/screens/home_screen.dart';
import 'package:prac5/features/books/screens/all_books_screen.dart';
import 'package:prac5/features/books/screens/read_books_screen.dart';
import 'package:prac5/features/books/screens/want_to_read_screen.dart';
import 'package:prac5/services/theme_service.dart';

class MainNavigationShell extends StatefulWidget {
  final List<Book> books;
  final Function(Book) onAddBook;
  final Function(String) onDeleteBook;
  final Function(String, bool) onToggleRead;
  final Function(String, int) onRateBook;
  final Function(Book) onUpdateBook;
  final ThemeService themeService;

  const MainNavigationShell({
    super.key,
    required this.books,
    required this.onAddBook,
    required this.onDeleteBook,
    required this.onToggleRead,
    required this.onRateBook,
    required this.onUpdateBook,
    required this.themeService,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        books: widget.books,
        onAddBook: widget.onAddBook,
        onDeleteBook: widget.onDeleteBook,
        onToggleRead: widget.onToggleRead,
        onRateBook: widget.onRateBook,
        onUpdateBook: widget.onUpdateBook,
        themeService: widget.themeService,
      ),
      AllBooksScreen(
        books: widget.books,
        onDeleteBook: widget.onDeleteBook,
        onToggleRead: widget.onToggleRead,
        onRateBook: widget.onRateBook,
        onUpdateBook: widget.onUpdateBook,
      ),
      ReadBooksScreen(
        books: widget.books.where((book) => book.isRead).toList(),
        onDeleteBook: widget.onDeleteBook,
        onToggleRead: widget.onToggleRead,
        onRateBook: widget.onRateBook,
        onUpdateBook: widget.onUpdateBook,
      ),
      WantToReadScreen(
        books: widget.books.where((book) => !book.isRead).toList(),
        onDeleteBook: widget.onDeleteBook,
        onToggleRead: widget.onToggleRead,
        onRateBook: widget.onRateBook,
        onUpdateBook: widget.onUpdateBook,
      ),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
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
    );
  }
}
