import 'package:flutter/material.dart';
import 'package:prac5/shared/app_theme.dart';
import 'package:prac5/features/books/books_feature.dart';
import 'package:prac5/features/navigation/main_navigation_shell.dart';
import 'package:prac5/services/theme_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _themeService.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _themeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Список книг',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeService.themeMode,
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
            themeService: _themeService,
          );
        },
      ),
    );
  }
}
