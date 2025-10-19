import 'package:flutter/material.dart';
import 'package:prac5/shared/app_theme.dart';
import 'package:prac5/features/books/books_feature.dart';
import 'package:prac5/features/navigation/main_navigation_shell.dart';

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
          return MainNavigationShell(
            books: books,
            onAddBook: onAddBook,
            onDeleteBook: onDeleteBook,
            onToggleRead: onToggleRead,
            onRateBook: onRateBook,
            onUpdateBook: onUpdateBook,
          );
        },
      ),
    );
  }
}
