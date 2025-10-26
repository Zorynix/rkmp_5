import 'package:equatable/equatable.dart';
import 'package:prac5/features/books/models/book.dart';

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object?> get props => [];
}

class BooksInitial extends BooksState {
  const BooksInitial();
}

class BooksLoading extends BooksState {
  const BooksLoading();
}

class BooksLoaded extends BooksState {
  final List<Book> books;

  const BooksLoaded(this.books);

  @override
  List<Object?> get props => [books];

  int get totalBooks => books.length;

  int get readBooks => books.where((book) => book.isRead).length;

  int get wantToReadBooks => totalBooks - readBooks;

  double get averageRating {
    final ratedBooks = books.where((book) => book.rating != null);
    if (ratedBooks.isEmpty) return 0.0;

    final sum = ratedBooks.map((book) => book.rating!).reduce((a, b) => a + b);
    return sum / ratedBooks.length;
  }

  List<Book> get recentBooks {
    if (books.isEmpty) return [];

    final sorted = books.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return sorted.take(5).toList();
  }

  List<Book> get readBooksList => books.where((book) => book.isRead).toList();

  List<Book> get wantToReadBooksList => books.where((book) => !book.isRead).toList();
}

class BooksError extends BooksState {
  final String message;

  const BooksError(this.message);

  @override
  List<Object?> get props => [message];
}

