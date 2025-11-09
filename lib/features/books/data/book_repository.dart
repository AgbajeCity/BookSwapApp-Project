import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Providers to access the repository
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider((ref) => FirebaseAuth.instance);

final bookRepositoryProvider = Provider((ref) {
  return BookRepository(
    ref.watch(firestoreProvider),
    ref.watch(authProvider),
  );
});

class BookRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  BookRepository(this._firestore, this._auth);

  // Get the 'books' collection
  CollectionReference get _books => _firestore.collection('books');
  User? get currentUser => _auth.currentUser;

  // 1. CREATE: Post a new book
  Future<void> postBook(Book book) async {
    if (currentUser == null) throw 'User not logged in';
    await _books.add(book.toMap());
  }

  // 2. READ: Get a stream of all available books
  Stream<List<Book>> getAvailableBooks() {
    return _books
        .where('status', isEqualTo: 'available')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
    });
  }

  // 3. READ: Get a stream of the user's own books
  Stream<List<Book>> getMyListings() {
    if (currentUser == null) return Stream.value([]);
    return _books
        .where('ownerId', isEqualTo: currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
    });
  }

  // 4. UPDATE: Edit a book
  Future<void> updateBook(Book book) async {
    await _books.doc(book.id).update(book.toMap());
  }

  // 5. DELETE: Delete a book
  Future<void> deleteBook(String bookId) async {
    await _books.doc(bookId).delete();
  }
}
