import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class AllBooksScreen extends StatefulWidget {
  final List<Book> books;
  final Function(String) onDeleteBook;
  final Function(String, bool) onToggleRead;
  final Function(String, int) onRateBook;
  final Function(Book) onUpdateBook;

  const AllBooksScreen({
    super.key,
    required this.books,
    required this.onDeleteBook,
    required this.onToggleRead,
    required this.onRateBook,
    required this.onUpdateBook,
  });

  @override
  State<AllBooksScreen> createState() => _AllBooksScreenState();
}

class _AllBooksScreenState extends State<AllBooksScreen> {
  String _searchQuery = '';
  String _selectedGenre = 'Все';
  String _sortBy = 'dateAdded';

  List<Book> get _filteredBooks {
    var filtered = widget.books.where((book) {
      final matchesSearch = book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGenre = _selectedGenre == 'Все' || book.genre == _selectedGenre;
      return matchesSearch && matchesGenre;
    }).toList();

    switch (_sortBy) {
      case 'title':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'author':
        filtered.sort((a, b) => a.author.compareTo(b.author));
        break;
      case 'rating':
        filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'dateAdded':
      default:
        filtered.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    }

    return filtered;
  }

  List<String> get _genres {
    final genres = widget.books.map((book) => book.genre).toSet().toList();
    genres.sort();
    return ['Все', ...genres];
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _filteredBooks;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Поиск по названию или автору',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedGenre,
                      decoration: const InputDecoration(
                        labelText: 'Жанр',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _genres.map((genre) {
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _sortBy,
                      decoration: const InputDecoration(
                        labelText: 'Сортировка',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'dateAdded', child: Text('По дате')),
                        DropdownMenuItem(value: 'title', child: Text('По названию')),
                        DropdownMenuItem(value: 'author', child: Text('По автору')),
                        DropdownMenuItem(value: 'rating', child: Text('По оценке')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredBooks.isEmpty
              ? const EmptyState(
                  icon: Icons.search_off,
                  title: 'Книги не найдены',
                  subtitle: 'Попробуйте изменить фильтры',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    return BookTile(
                      key: ValueKey(book.id),
                      book: book,
                      onDelete: () => widget.onDeleteBook(book.id),
                      onToggleRead: (isRead) => widget.onToggleRead(book.id, isRead),
                      onRate: (rating) => widget.onRateBook(book.id, rating),
                      onUpdate: widget.onUpdateBook,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
