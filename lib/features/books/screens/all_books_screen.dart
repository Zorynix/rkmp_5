import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/features/books/widgets/book_tile.dart';
import 'package:prac5/shared/widgets/empty_state.dart';
import 'package:prac5/core/widgets/app_state_inherited_widget.dart';

class AllBooksScreen extends StatefulWidget {
  const AllBooksScreen({super.key});

  @override
  State<AllBooksScreen> createState() => _AllBooksScreenState();
}

class _AllBooksScreenState extends State<AllBooksScreen> {
  String _searchQuery = '';
  String _selectedGenre = 'Все';
  String _sortBy = 'dateAdded';

  List<Book> _getFilteredBooks(List<Book> books) {
    var filtered = books.where((book) {
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

  List<String> _getGenres(List<Book> books) {
    final genres = books.map((book) => book.genre).toSet().toList();
    genres.sort();
    return ['Все', ...genres];
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateInheritedWidget.of(context);

    if (appState == null) {
      return const Scaffold(
        body: Center(child: Text('Ошибка: AppState не найден')),
      );
    }

    final filteredBooks = _getFilteredBooks(appState.books);
    final genres = _getGenres(appState.books);

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
                      items: genres.map((genre) {
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
                      onDelete: () => appState.onDeleteBook(book.id),
                      onToggleRead: (isRead) => appState.onToggleRead(book.id, isRead),
                      onRate: (rating) => appState.onRateBook(book.id, rating),
                      onUpdate: appState.onUpdateBook,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
