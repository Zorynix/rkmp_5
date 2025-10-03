import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
import 'features/books/books_feature.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Библиотека книг',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: BooksContainer(
        builder: (context, books, onAddBook, onDeleteBook, onToggleRead, onRateBook) {
          return HomeScreen(
            books: books,
            onAddBook: onAddBook,
            onDeleteBook: onDeleteBook,
            onToggleRead: onToggleRead,
            onRateBook: onRateBook,
          );
        },
      ),
    );
  }
}
