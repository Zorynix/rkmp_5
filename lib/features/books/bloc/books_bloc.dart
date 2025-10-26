import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/books/bloc/books_event.dart';
import 'package:prac5/features/books/bloc/books_state.dart';
import 'package:prac5/features/books/models/book.dart';
import 'package:prac5/core/di/service_locator.dart';
import 'package:prac5/services/logger_service.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  BooksBloc() : super(const BooksInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<AddBook>(_onAddBook);
    on<UpdateBook>(_onUpdateBook);
    on<DeleteBook>(_onDeleteBook);
    on<ToggleBookRead>(_onToggleBookRead);
    on<RateBook>(_onRateBook);
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BooksState> emit) async {
    try {
      emit(const BooksLoading());
      emit(const BooksLoaded([]));
    } catch (e) {
      LoggerService.error('Ошибка загрузки книг: $e');
      emit(BooksError('Не удалось загрузить книги: $e'));
    }
  }

  Future<void> _onAddBook(AddBook event, Emitter<BooksState> emit) async {
    try {
      if (state is BooksLoaded) {
        final currentState = state as BooksLoaded;

        final imageUrl = await Services.image.getNextBookImage();
        final bookWithImage = event.book.copyWith(imageUrl: imageUrl);

        final updatedBooks = List<Book>.from(currentState.books)..add(bookWithImage);
        emit(BooksLoaded(updatedBooks));

        LoggerService.info('Книга добавлена: ${bookWithImage.title}');
      }
    } catch (e) {
      LoggerService.error('Ошибка добавления книги: $e');
      emit(BooksError('Не удалось добавить книгу: $e'));

      if (state is BooksLoaded) {
        emit(state as BooksLoaded);
      }
    }
  }

  Future<void> _onUpdateBook(UpdateBook event, Emitter<BooksState> emit) async {
    try {
      if (state is BooksLoaded) {
        final currentState = state as BooksLoaded;
        final updatedBooks = currentState.books.map((book) {
          return book.id == event.book.id ? event.book : book;
        }).toList();

        emit(BooksLoaded(updatedBooks));
        LoggerService.info('Книга обновлена: ${event.book.title}');
      }
    } catch (e) {
      LoggerService.error('Ошибка обновления книги: $e');
      emit(BooksError('Не удалось обновить книгу: $e'));

      if (state is BooksLoaded) {
        emit(state as BooksLoaded);
      }
    }
  }

  Future<void> _onDeleteBook(DeleteBook event, Emitter<BooksState> emit) async {
    try {
      if (state is BooksLoaded) {
        final currentState = state as BooksLoaded;
        final bookToDelete = currentState.books.firstWhere((book) => book.id == event.bookId);

        if (bookToDelete.imageUrl != null) {
          await Services.image.releaseImage(bookToDelete.imageUrl!);
        }

        final updatedBooks = currentState.books.where((book) => book.id != event.bookId).toList();
        emit(BooksLoaded(updatedBooks));

        LoggerService.info('Книга удалена: ${bookToDelete.title}');
      }
    } catch (e) {
      LoggerService.error('Ошибка удаления книги: $e');
      emit(BooksError('Не удалось удалить книгу: $e'));

      if (state is BooksLoaded) {
        emit(state as BooksLoaded);
      }
    }
  }

  Future<void> _onToggleBookRead(ToggleBookRead event, Emitter<BooksState> emit) async {
    try {
      if (state is BooksLoaded) {
        final currentState = state as BooksLoaded;
        final updatedBooks = currentState.books.map((book) {
          if (book.id == event.bookId) {
            return book.copyWith(
              isRead: event.isRead,
              dateFinished: event.isRead ? DateTime.now() : null,
            );
          }
          return book;
        }).toList();

        emit(BooksLoaded(updatedBooks));
        LoggerService.info('Статус чтения изменен для книги ID: ${event.bookId}');
      }
    } catch (e) {
      LoggerService.error('Ошибка изменения статуса чтения: $e');
      emit(BooksError('Не удалось изменить статус: $e'));

      if (state is BooksLoaded) {
        emit(state as BooksLoaded);
      }
    }
  }

  Future<void> _onRateBook(RateBook event, Emitter<BooksState> emit) async {
    try {
      if (state is BooksLoaded) {
        final currentState = state as BooksLoaded;
        final updatedBooks = currentState.books.map((book) {
          if (book.id == event.bookId) {
            return book.copyWith(rating: event.rating);
          }
          return book;
        }).toList();

        emit(BooksLoaded(updatedBooks));
        LoggerService.info('Оценка книги изменена ID: ${event.bookId}, рейтинг: ${event.rating}');
      }
    } catch (e) {
      LoggerService.error('Ошибка оценки книги: $e');
      emit(BooksError('Не удалось оценить книгу: $e'));

      if (state is BooksLoaded) {
        emit(state as BooksLoaded);
      }
    }
  }
}

