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
  final String? imageUrl;

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
    this.imageUrl,
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
    String? imageUrl,
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
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
