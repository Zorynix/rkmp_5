import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/features/books/screens/book_form_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final VoidCallback onDelete;
  final Function(bool) onToggleRead;
  final Function(int) onRate;
  final Function(Book) onUpdate;

  const BookDetailScreen({
    super.key,
    required this.book,
    required this.onDelete,
    required this.onToggleRead,
    required this.onRate,
    required this.onUpdate,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Book _currentBook;

  @override
  void initState() {
    super.initState();
    _currentBook = widget.book;
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Оценить книгу'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final rating = index + 1;
                return IconButton(
                  icon: Icon(
                    rating <= (_currentBook.rating ?? 0) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                  onPressed: () {
                    widget.onRate(rating);
                    setState(() {
                      _currentBook = _currentBook.copyWith(rating: rating);
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить книгу?'),
        content: Text('Вы уверены, что хотите удалить "${_currentBook.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              widget.onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookFormScreen(
          book: _currentBook,
          onSave: (updatedBook) {
            widget.onUpdate(updatedBook);
            setState(() {
              _currentBook = updatedBook;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _toggleReadStatus() {
    final newIsRead = !_currentBook.isRead;
    widget.onToggleRead(newIsRead);
    setState(() {
      _currentBook = _currentBook.copyWith(
        isRead: newIsRead,
        dateFinished: newIsRead ? DateTime.now() : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали книги'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditScreen(context),
            tooltip: 'Редактировать',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
            tooltip: 'Удалить',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentBook.imageUrl != null)
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[200],
                child: CachedNetworkImage(
                  imageUrl: _currentBook.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _currentBook.isRead ? Colors.green : Colors.orange,
                          _currentBook.isRead ? Colors.green.shade300 : Colors.orange.shade300,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.menu_book,
                        size: 100,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _currentBook.isRead ? Colors.green : Colors.orange,
                    _currentBook.isRead ? Colors.green.shade300 : Colors.orange.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _currentBook.isRead ? Icons.check_circle : Icons.schedule,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentBook.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentBook.author,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if (_currentBook.rating != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < _currentBook.rating! ? Icons.star : Icons.star_border,
                          color: Colors.white,
                          size: 24,
                        );
                      }),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.category, 'Жанр', _currentBook.genre),
                  if (_currentBook.pages != null)
                    _buildInfoRow(Icons.menu_book, 'Страниц', '${_currentBook.pages}'),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Добавлено',
                    dateFormat.format(_currentBook.dateAdded),
                  ),
                  if (_currentBook.dateFinished != null)
                    _buildInfoRow(
                      Icons.check,
                      'Прочитано',
                      dateFormat.format(_currentBook.dateFinished!),
                    ),
                  if (_currentBook.description != null && _currentBook.description!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Описание',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentBook.description!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _toggleReadStatus,
                          icon: Icon(_currentBook.isRead ? Icons.undo : Icons.check),
                          label: Text(
                            _currentBook.isRead ? 'Вернуть в список' : 'Отметить прочитанной',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () => _showRatingDialog(context),
                        icon: const Icon(Icons.star),
                        label: const Text('Оценить'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
