import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/shared/constants.dart';

class BookFormScreen extends StatefulWidget {
  final Function(Book) onSave;
  final Book? book;

  const BookFormScreen({
    super.key,
    required this.onSave,
    this.book,
  });

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pagesController = TextEditingController();
  String _selectedGenre = AppConstants.genres.first;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _selectedGenre = widget.book!.genre;
      _descriptionController.text = widget.book!.description ?? '';
      _pagesController.text = widget.book!.pages?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      final book = widget.book?.copyWith(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        genre: _selectedGenre,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        pages: _pagesController.text.trim().isEmpty
            ? null
            : int.tryParse(_pagesController.text.trim()),
      ) ?? Book(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        genre: _selectedGenre,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        pages: _pagesController.text.trim().isEmpty
            ? null
            : int.tryParse(_pagesController.text.trim()),
      );
      widget.onSave(book);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать книгу' : 'Добавить книгу'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название книги *',
                  hintText: 'Введите название',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Автор *',
                  hintText: 'Введите имя автора',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите автора';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Жанр *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  prefixIcon: Icon(Icons.category),
                ),
                items: AppConstants.genres.map((genre) {
                  return DropdownMenuItem(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGenre = value!;
                  });
                },
                initialValue: _selectedGenre,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pagesController,
                decoration: const InputDecoration(
                  labelText: 'Количество страниц',
                  hintText: 'Введите количество страниц',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (int.tryParse(value.trim()) == null) {
                      return 'Введите корректное число';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  hintText: 'Краткое описание книги',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveBook,
                icon: Icon(isEditing ? Icons.save : Icons.add),
                label: Text(isEditing ? 'Сохранить изменения' : 'Добавить книгу'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
