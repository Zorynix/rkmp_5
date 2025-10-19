import 'package:flutter/material.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/features/navigation_demo/page_view_navigation.dart';

class NavigationSelector extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onAddBook;
  final Function(String) onDeleteBook;
  final Function(String, bool) onToggleRead;
  final Function(String, int) onRateBook;
  final Function(Book) onUpdateBook;

  const NavigationSelector({
    super.key,
    required this.books,
    required this.onAddBook,
    required this.onDeleteBook,
    required this.onToggleRead,
    required this.onRateBook,
    required this.onUpdateBook,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор типа навигации'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.navigation,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              const Text(
                'Демонстрация навигации',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Выберите тип навигации для работы с приложением',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildNavigationCard(
                context: context,
                icon: Icons.swipe,
                title: 'Страничная навигация',
                subtitle: 'Горизонтальная навигация через PageView\nСвайп влево/вправо между экранами',
                color: Colors.blue,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageViewNavigation(
                        books: books,
                        onAddBook: onAddBook,
                        onDeleteBook: onDeleteBook,
                        onToggleRead: onToggleRead,
                        onRateBook: onRateBook,
                        onUpdateBook: onUpdateBook,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildNavigationCard(
                context: context,
                icon: Icons.route,
                title: 'Маршрутизированная навигация',
                subtitle: 'Вертикальная навигация через именованные routes\nПереходы между экранами по кнопкам',
                color: Colors.green,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/route-home',
                    arguments: {
                      'books': books,
                      'onAddBook': onAddBook,
                      'onDeleteBook': onDeleteBook,
                      'onToggleRead': onToggleRead,
                      'onRateBook': onRateBook,
                      'onUpdateBook': onUpdateBook,
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
