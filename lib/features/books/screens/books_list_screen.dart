import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_tile.dart';
import 'book_form_screen.dart';

class BooksListScreen extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onAddBook;
  final Function(String) onDeleteBook;
  final Function(String, bool) onToggleRead;
  final Function(String, int) onRateBook;
  final Function(Book) onUpdateBook;

  const BooksListScreen({
    super.key,
    required this.books,
    required this.onAddBook,
    required this.onDeleteBook,
    required this.onToggleRead,
    required this.onRateBook,
    required this.onUpdateBook,
  });

  void _showAddBookDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookFormScreen(
          onSave: (book) {
            onAddBook(book);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список книг'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: books.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Список пуст',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Добавьте первую книгу',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: books.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final book = books[index];
                return BookTile(
                  key: ValueKey(book.id),
                  book: book,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBookDialog(context),
        tooltip: 'Добавить книгу',
        child: const Icon(Icons.add),
      ),
    );
  }
}
