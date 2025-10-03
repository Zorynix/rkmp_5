import 'package:flutter/material.dart';
import '../models/book.dart';

class BooksContainer extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    List<Book> books,
    Function(Book) onAddBook,
    Function(String) onDeleteBook,
    Function(String, bool) onToggleRead,
    Function(String, int) onRateBook,
  ) builder;

  const BooksContainer({
    super.key,
    required this.builder,
  });

  @override
  State<BooksContainer> createState() => _BooksContainerState();
}

class _BooksContainerState extends State<BooksContainer> {
  final List<Book> _books = [];

  void _addBook(Book book) {
    setState(() {
      _books.add(book);
    });
  }

  void _deleteBook(String id) {
    setState(() {
      _books.removeWhere((book) => book.id == id);
    });
  }

  void _toggleRead(String id, bool isRead) {
    setState(() {
      final index = _books.indexWhere((book) => book.id == id);
      if (index != -1) {
        _books[index].isRead = isRead;
        _books[index].dateFinished = isRead ? DateTime.now() : null;
      }
    });
  }

  void _rateBook(String id, int rating) {
    setState(() {
      final index = _books.indexWhere((book) => book.id == id);
      if (index != -1) {
        _books[index].rating = rating;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _books,
      _addBook,
      _deleteBook,
      _toggleRead,
      _rateBook,
    );
  }
}
