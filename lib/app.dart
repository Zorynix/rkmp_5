import 'package:flutter/material.dart';
import 'package:prac5/shared/app_theme.dart';
import 'package:prac5/features/books/books_feature.dart';
import 'package:prac5/features/navigation/main_navigation_shell.dart';
import 'package:prac5/core/di/service_locator.dart';
import 'package:prac5/core/widgets/app_state_inherited_widget.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Services.theme.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    Services.theme.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Список книг',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Services.theme.themeMode,
      debugShowCheckedModeBanner: false,
      home: BooksContainer(
        builder: (context, books, onAddBook, onDeleteBook, onToggleRead, onRateBook, onUpdateBook) {
          return AppStateInheritedWidget(
            books: books,
            onAddBook: onAddBook,
            onDeleteBook: onDeleteBook,
            onToggleRead: onToggleRead,
            onRateBook: onRateBook,
            onUpdateBook: onUpdateBook,
            themeService: Services.theme,
            child: const MainNavigationShell(),
          );
        },
      ),
    );
  }
}
