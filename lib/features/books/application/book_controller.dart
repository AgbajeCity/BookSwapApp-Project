import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/book_model.dart';
import '../data/book_repository.dart';

// This provider will be watched by the UI for loading/error states
final bookControllerProvider =
    StateNotifierProvider<BookController, AsyncValue<void>>((ref) {
  return BookController(ref.watch(bookRepositoryProvider));
});

class BookController extends StateNotifier<AsyncValue<void>> {
  final BookRepository _bookRepository;

  BookController(this._bookRepository) : super(const AsyncData(null));

  // 1. CREATE
  Future<void> postBook({
    required String title,
    required String author,
    required String condition,
  }) async {
    state = const AsyncLoading();
    const String placeholderImageUrl = 'https://i.imgur.com/SFeY21M.jpeg';

    final user = _bookRepository.currentUser;
    if (user == null) {
      state = const AsyncError('User not logged in', StackTrace.empty);
      return;
    }

    final newBook = Book(
      id: '',
      title: title,
      author: author,
      condition: condition,
      coverImageUrl: placeholderImageUrl,
      ownerId: user.uid,
      ownerEmail: user.email ?? 'No Email',
    );

    state = await AsyncValue.guard(
      () => _bookRepository.postBook(newBook),
    );
  }

  // 2. UPDATE: Edit an existing book
  Future<void> editBook(Book updatedBook) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _bookRepository.updateBook(updatedBook),
    );
  }

  // 3. DELETE: Remove a book from the listings
  Future<void> deleteListing(String bookId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _bookRepository.deleteBook(bookId),
    );
  }

  // 4. SWAP: Initiate a swap request
  Future<void> requestSwap(Book book) async {
    state = const AsyncLoading();
    final user = _bookRepository.currentUser;

    if (user == null) {
      state = const AsyncError('User not logged in', StackTrace.empty);
      return;
    }

    // Create a copy of the book with the new status and requester ID
    final pendingBook = book.copyWith(
      status: 'pending',
      requesterId: user.uid,
    );

    // Update the book in Firestore
    state = await AsyncValue.guard(
      () => _bookRepository.updateBook(pendingBook),
    );
  }
}

