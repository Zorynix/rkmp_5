import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/features/books/data/repositories/books_repository.dart';
import 'package:prac5/features/books/data/datasources/books_local_datasource.dart';
import 'package:prac5/services/logger_service.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksLocalDataSource _localDataSource;

  BooksRepositoryImpl({
    required BooksLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<List<Book>> getBooks() async {
    try {
      return await _localDataSource.getBooks();
    } catch (e) {
      LoggerService.error('BooksRepository: Ошибка получения книг: $e');
      rethrow;
    }
  }

  @override
  Future<void> addBook(Book book) async {
    try {
      final books = await getBooks();
      books.add(book);
      await _localDataSource.saveBooks(books);
      LoggerService.info('BooksRepository: Книга добавлена: ${book.title}');
    } catch (e) {
      LoggerService.error('BooksRepository: Ошибка добавления книги: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateBook(Book book) async {
    try {
      final books = await getBooks();
      final index = books.indexWhere((b) => b.id == book.id);

      if (index != -1) {
        books[index] = book;
        await _localDataSource.saveBooks(books);
        LoggerService.info('BooksRepository: Книга обновлена: ${book.title}');
      } else {
        throw Exception('Книга с ID ${book.id} не найдена');
      }
    } catch (e) {
      LoggerService.error('BooksRepository: Ошибка обновления книги: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBook(String id) async {
    try {
      final books = await getBooks();
      books.removeWhere((book) => book.id == id);
      await _localDataSource.saveBooks(books);
      LoggerService.info('BooksRepository: Книга удалена: $id');
    } catch (e) {
      LoggerService.error('BooksRepository: Ошибка удаления книги: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveBooks(List<Book> books) async {
    try {
      await _localDataSource.saveBooks(books);
    } catch (e) {
      LoggerService.error('BooksRepository: Ошибка сохранения книг: $e');
      rethrow;
    }
  }
}

