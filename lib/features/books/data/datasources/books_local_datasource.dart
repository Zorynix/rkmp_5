import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/services/logger_service.dart';


class BooksLocalDataSource {
  static const String _booksKey = 'books_data';

  Future<List<Book>> getBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? booksJson = prefs.getString(_booksKey);

      if (booksJson == null || booksJson.isEmpty) {
        LoggerService.info('BooksLocalDataSource: Нет сохраненных книг');
        return [];
      }

      final List<dynamic> decoded = json.decode(booksJson);
      final books = decoded.map((json) => _bookFromJson(json)).toList();

      LoggerService.info('BooksLocalDataSource: Загружено ${books.length} книг');
      return books;
    } catch (e) {
      LoggerService.error('BooksLocalDataSource: Ошибка загрузки книг: $e');
      return [];
    }
  }

  Future<void> saveBooks(List<Book> books) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = json.encode(books.map((book) => _bookToJson(book)).toList());
      await prefs.setString(_booksKey, booksJson);

      LoggerService.info('BooksLocalDataSource: Сохранено ${books.length} книг');
    } catch (e) {
      LoggerService.error('BooksLocalDataSource: Ошибка сохранения книг: $e');
      rethrow;
    }
  }

  Future<void> clearBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_booksKey);
      LoggerService.info('BooksLocalDataSource: Книги удалены из хранилища');
    } catch (e) {
      LoggerService.error('BooksLocalDataSource: Ошибка очистки книг: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _bookToJson(Book book) {
    return {
      'id': book.id,
      'title': book.title,
      'author': book.author,
      'genre': book.genre,
      'description': book.description,
      'pages': book.pages,
      'isRead': book.isRead,
      'rating': book.rating,
      'dateAdded': book.dateAdded.toIso8601String(),
      'dateFinished': book.dateFinished?.toIso8601String(),
      'imageUrl': book.imageUrl,
    };
  }

  Book _bookFromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      genre: json['genre'] as String,
      description: json['description'] as String?,
      pages: json['pages'] as int?,
      isRead: json['isRead'] as bool? ?? false,
      rating: json['rating'] as int?,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      dateFinished: json['dateFinished'] != null
          ? DateTime.parse(json['dateFinished'] as String)
          : null,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

