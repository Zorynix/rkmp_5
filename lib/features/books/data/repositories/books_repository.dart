import 'package:prac5/features/books/models/book.dart';

abstract class BooksRepository {
  Future<List<Book>> getBooks();

  Future<void> addBook(Book book);

  Future<void> updateBook(Book book);

  Future<void> deleteBook(String id);

  Future<void> saveBooks(List<Book> books);
}
