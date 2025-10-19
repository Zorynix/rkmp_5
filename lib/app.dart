import 'package:flutter/material.dart';
import 'package:prac5/shared/app_theme.dart';
import 'package:prac5/features/books/books_feature.dart';
import 'package:prac5/features/navigation/navigation_selector.dart';
import 'package:prac5/features/navigation/route_navigation.dart';
import 'package:prac5/features/profile/profile_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Список книг',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: BooksContainer(
        builder: (context, books, onAddBook, onDeleteBook, onToggleRead, onRateBook, onUpdateBook) {
          return NavigationSelector(
            books: books,
            onAddBook: onAddBook,
            onDeleteBook: onDeleteBook,
            onToggleRead: onToggleRead,
            onRateBook: onRateBook,
            onUpdateBook: onUpdateBook,
          );
        },
      ),
      routes: {
        '/route-home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return RouteNavigation(
            books: args['books'],
            onAddBook: args['onAddBook'],
            onDeleteBook: args['onDeleteBook'],
            onToggleRead: args['onToggleRead'],
            onRateBook: args['onRateBook'],
            onUpdateBook: args['onUpdateBook'],
          );
        },
        '/all-books': (context) {
          return BooksContainer(
            builder: (context, books, onAddBook, onDeleteBook, onToggleRead, onRateBook, onUpdateBook) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Все книги'),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                body: AllBooksScreen(
                  books: books,
                  onDeleteBook: onDeleteBook,
                  onToggleRead: onToggleRead,
                  onRateBook: onRateBook,
                  onUpdateBook: onUpdateBook,
                ),
              );
            },
          );
        },
        '/read-books': (context) {
          return BooksContainer(
            builder: (context, books, onAddBook, onDeleteBook, onToggleRead, onRateBook, onUpdateBook) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Прочитанные книги'),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                body: ReadBooksScreen(
                  books: books.where((book) => book.isRead).toList(),
                  onDeleteBook: onDeleteBook,
                  onToggleRead: onToggleRead,
                  onRateBook: onRateBook,
                  onUpdateBook: onUpdateBook,
                ),
              );
            },
          );
        },
        '/want-to-read': (context) {
          return BooksContainer(
            builder: (context, books, onAddBook, onDeleteBook, onToggleRead, onRateBook, onUpdateBook) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Хочу прочитать'),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                body: WantToReadScreen(
                  books: books.where((book) => !book.isRead).toList(),
                  onDeleteBook: onDeleteBook,
                  onToggleRead: onToggleRead,
                  onRateBook: onRateBook,
                  onUpdateBook: onUpdateBook,
                ),
              );
            },
          );
        },
        '/profile': (context) {
          return const ProfileScreen();
        },
      },
    );
  }
}
