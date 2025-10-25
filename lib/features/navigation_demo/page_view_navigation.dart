// import 'package:flutter/material.dart';
// import 'package:prac5/features/books/models/book.dart';
// import 'package:prac5/features/books/screens/all_books_screen.dart';
// import 'package:prac5/features/books/screens/read_books_screen.dart';
// import 'package:prac5/features/books/screens/want_to_read_screen.dart';
// import 'package:prac5/features/books/screens/book_form_screen.dart';
// import 'package:prac5/features/books/widgets/statistics_card.dart';
// import 'package:prac5/features/books/widgets/book_tile.dart';
// import 'package:prac5/features/profile/profile_screen.dart';
//
// class PageViewNavigation extends StatefulWidget {
//   final List<Book> books;
//   final Function(Book) onAddBook;
//   final Function(String) onDeleteBook;
//   final Function(String, bool) onToggleRead;
//   final Function(String, int) onRateBook;
//   final Function(Book) onUpdateBook;
//
//   const PageViewNavigation({
//     super.key,
//     required this.books,
//     required this.onAddBook,
//     required this.onDeleteBook,
//     required this.onToggleRead,
//     required this.onRateBook,
//     required this.onUpdateBook,
//   });
//
//   @override
//   State<PageViewNavigation> createState() => _PageViewNavigationState();
// }
//
// class _PageViewNavigationState extends State<PageViewNavigation> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _showAddBookDialog() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BookFormScreen(
//           onSave: (book) {
//             widget.onAddBook(book);
//             Navigator.pop(context);
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHomeTab() {
//     final totalBooks = widget.books.length;
//     final readBooks = widget.books.where((book) => book.isRead).length;
//     final wantToRead = totalBooks - readBooks;
//     final averageRating = widget.books.where((book) => book.rating != null).isEmpty
//         ? 0.0
//         : widget.books
//                 .where((book) => book.rating != null)
//                 .map((book) => book.rating!)
//                 .reduce((a, b) => a + b) /
//             widget.books.where((book) => book.rating != null).length;
//
//     final recentBooks = widget.books.isEmpty
//         ? <Book>[]
//         : (widget.books.toList()
//           ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded)))
//             .take(5)
//             .toList();
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Статистика',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             mainAxisSpacing: 12,
//             crossAxisSpacing: 12,
//             childAspectRatio: 1.5,
//             children: [
//               StatisticsCard(
//                 title: 'Всего книг',
//                 value: totalBooks.toString(),
//                 icon: Icons.menu_book,
//                 color: Colors.indigo,
//               ),
//               StatisticsCard(
//                 title: 'Прочитано',
//                 value: readBooks.toString(),
//                 icon: Icons.check_circle,
//                 color: Colors.green,
//               ),
//               StatisticsCard(
//                 title: 'Хочу прочитать',
//                 value: wantToRead.toString(),
//                 icon: Icons.schedule,
//                 color: Colors.orange,
//               ),
//               StatisticsCard(
//                 title: 'Средняя оценка',
//                 value: averageRating.toStringAsFixed(1),
//                 icon: Icons.star,
//                 color: Colors.amber,
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'Недавно добавленные',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),
//           if (recentBooks.isEmpty)
//             const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(32),
//                 child: Text(
//                   'Книг пока нет\nДобавьте первую книгу',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             )
//           else
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: recentBooks.length,
//               itemBuilder: (context, index) {
//                 final book = recentBooks[index];
//                 return BookTile(
//                   key: ValueKey(book.id),
//                   book: book,
//                   onDelete: () => widget.onDeleteBook(book.id),
//                   onToggleRead: (isRead) => widget.onToggleRead(book.id, isRead),
//                   onRate: (rating) => widget.onRateBook(book.id, rating),
//                   onUpdate: widget.onUpdateBook,
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       _buildHomeTab(),
//       AllBooksScreen(
//         books: widget.books,
//         onDeleteBook: widget.onDeleteBook,
//         onToggleRead: widget.onToggleRead,
//         onRateBook: widget.onRateBook,
//         onUpdateBook: widget.onUpdateBook,
//       ),
//       ReadBooksScreen(
//         books: widget.books.where((book) => book.isRead).toList(),
//         onDeleteBook: widget.onDeleteBook,
//         onToggleRead: widget.onToggleRead,
//         onRateBook: widget.onRateBook,
//         onUpdateBook: widget.onUpdateBook,
//       ),
//       WantToReadScreen(
//         books: widget.books.where((book) => !book.isRead).toList(),
//         onDeleteBook: widget.onDeleteBook,
//         onToggleRead: widget.onToggleRead,
//         onRateBook: widget.onRateBook,
//         onUpdateBook: widget.onUpdateBook,
//       ),
//       const ProfileScreen(),
//     ];
//
//     final titles = [
//       'Главная',
//       'Все книги',
//       'Прочитанные',
//       'Хочу прочитать',
//       'Профиль'
//     ];
//
//     return Scaffold(
//       appBar: _currentPage == 4 ? null : AppBar(
//         title: Text(titles[_currentPage]),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Column(
//         children: [
//           if (_currentPage != 4)
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(5, (index) {
//                   return GestureDetector(
//                     onTap: () {
//                       _pageController.animateToPage(
//                         index,
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                       );
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       width: _currentPage == index ? 24 : 8,
//                       height: 8,
//                       decoration: BoxDecoration(
//                         color: _currentPage == index
//                             ? Theme.of(context).colorScheme.primary
//                             : Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           Expanded(
//             child: PageView(
//               controller: _pageController,
//               onPageChanged: (index) {
//                 setState(() {
//                   _currentPage = index;
//                 });
//               },
//               children: screens,
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: _currentPage != 4
//           ? FloatingActionButton(
//               onPressed: _showAddBookDialog,
//               tooltip: 'Добавить книгу',
//               child: const Icon(Icons.add),
//             )
//           : null,
//     );
//   }
// }
