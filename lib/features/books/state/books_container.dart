import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/services/image_service.dart';

class BooksContainer extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    List<Book> books,
    Function(Book) onAddBook,
    Function(String) onDeleteBook,
    Function(String, bool) onToggleRead,
    Function(String, int) onRateBook,
    Function(Book) onUpdateBook,
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
  final ImageService _imageService = ImageService();

  void _addBook(Book book) async {
    final imageUrl = await _imageService.getNextBookImage();
    final bookWithImage = book.copyWith(imageUrl: imageUrl);

    setState(() {
      _books.add(bookWithImage);
    });
  }

  void _updateBook(Book updatedBook) {
    setState(() {
      final index = _books.indexWhere((book) => book.id == updatedBook.id);
      if (index != -1) {
        _books[index] = updatedBook;
      }
    });
  }

  void _deleteBook(String id) async {
    final book = _books.firstWhere((book) => book.id == id);

    if (book.imageUrl != null) {
      await _imageService.releaseImage(book.imageUrl!);
    }

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
      _updateBook,
    );
  }
}
