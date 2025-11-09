import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prac5/core/di/service_locator.dart';
import 'package:prac5/features/auth/auth_screen.dart';
import 'package:prac5/features/books/screens/home_screen.dart';
import 'package:prac5/features/books/screens/read_books_screen.dart';
import 'package:prac5/features/books/screens/want_to_read_screen.dart';
import 'package:prac5/features/books/screens/all_books_screen.dart';
import 'package:prac5/features/books/screens/book_detail_screen.dart';
import 'package:prac5/features/books/screens/book_form_screen.dart';
import 'package:prac5/features/books/screens/my_collection_screen.dart';
import 'package:prac5/features/books/screens/ratings_screen.dart';
import 'package:prac5/features/books/screens/statistics_screen.dart';
import 'package:prac5/features/profile/profile_screen.dart';
import 'package:prac5/features/books/models/book.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isLoggedIn = await Services.auth.isLoggedIn();
      final isGoingToAuth = state.matchedLocation == '/auth';

      if (!isLoggedIn && !isGoingToAuth) {
        return '/auth';
      }

      if (isLoggedIn && isGoingToAuth) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/read-books',
        name: 'read-books',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Прочитанные книги'),
          ),
          body: const ReadBooksScreen(),
        ),
      ),
      GoRoute(
        path: '/want-to-read',
        name: 'want-to-read',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Планирую прочитать'),
          ),
          body: const WantToReadScreen(),
        ),
      ),
      GoRoute(
        path: '/all-books',
        name: 'all-books',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Все книги'),
          ),
          body: const AllBooksScreen(),
        ),
      ),
      GoRoute(
        path: '/my-collection',
        name: 'my-collection',
        builder: (context, state) => const MyCollectionScreen(),
      ),
      GoRoute(
        path: '/ratings',
        name: 'ratings',
        builder: (context, state) => const RatingsScreen(),
      ),
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: '/book/:id',
        name: 'book-detail',
        builder: (context, state) {
          final book = state.extra as Book;
          return BookDetailScreen(book: book);
        },
      ),
      GoRoute(
        path: '/book-form',
        name: 'book-form',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>?;
          final onSave = params?['onSave'] as Function(Book)?;
          final book = params?['book'] as Book?;

          return BookFormScreen(
            onSave: onSave ?? (book) {},
            book: book,
          );
        },
      ),
    ],
  );
}

