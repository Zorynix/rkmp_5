class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final String? description;
  final int? pages;
  bool isRead;
  int? rating;
  final DateTime dateAdded;
  DateTime? dateFinished;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    this.description,
    this.pages,
    this.isRead = false,
    this.rating,
    DateTime? dateAdded,
    this.dateFinished,
  }) : dateAdded = dateAdded ?? DateTime.now();

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? genre,
    String? description,
    int? pages,
    bool? isRead,
    int? rating,
    DateTime? dateAdded,
    DateTime? dateFinished,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      pages: pages ?? this.pages,
      isRead: isRead ?? this.isRead,
      rating: rating ?? this.rating,
      dateAdded: dateAdded ?? this.dateAdded,
      dateFinished: dateFinished ?? this.dateFinished,
    );
  }
}
