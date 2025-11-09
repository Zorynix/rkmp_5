import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/shared/app_theme.dart';
import 'package:prac5/features/books/bloc/books_bloc.dart';
import 'package:prac5/features/books/bloc/books_event.dart';
import 'package:prac5/features/theme/bloc/theme_cubit.dart';
import 'package:prac5/features/theme/bloc/theme_state.dart';
import 'package:prac5/features/navigation/main_navigation_shell.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BooksBloc()..add(const LoadBooks()),
        ),
        BlocProvider(
          create: (context) => ThemeCubit()..loadTheme(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final themeMode = themeState is ThemeLoaded
              ? themeState.themeMode
              : ThemeMode.light;

          return MaterialApp(
            title: 'Список книг',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            home: const MainNavigationShell(),
          );
        },
      ),
    );
  }
}
