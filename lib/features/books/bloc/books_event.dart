import 'package:equatable/equatable.dart';
import 'package:prac5/features/books/models/book.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object?> get props => [];
}

class LoadBooks extends BooksEvent {
  const LoadBooks();
}

class AddBook extends BooksEvent {
  final Book book;

  const AddBook(this.book);

  @override
  List<Object?> get props => [book];
}

class UpdateBook extends BooksEvent {
  final Book book;

  const UpdateBook(this.book);

  @override
  List<Object?> get props => [book];
}

class DeleteBook extends BooksEvent {
  final String bookId;

  const DeleteBook(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class ToggleBookRead extends BooksEvent {
  final String bookId;
  final bool isRead;

  const ToggleBookRead(this.bookId, this.isRead);

  @override
  List<Object?> get props => [bookId, isRead];
}

class RateBook extends BooksEvent {
  final String bookId;
  final int rating;

  const RateBook(this.bookId, this.rating);

  @override
  List<Object?> get props => [bookId, rating];
}

