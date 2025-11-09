import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'books/data/book_repository.dart';
import 'books/presentation/post_book_screen.dart'; // Used for the '+' button
import 'books/presentation/edit_book_screen.dart'; // Used for card tap
import 'books/presentation/book_list_card.dart';

// Create a StreamProvider to fetch *only* the user's books
final myBooksProvider = StreamProvider((ref) {
  return ref.watch(bookRepositoryProvider).getMyListings();
});

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myBooksAsync = ref.watch(myBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
      ),
      body: myBooksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 60, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    'No books listed yet.',
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first book!',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            );
          }

          // Display the list of books
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              // Correctly referencing BookListCard and EditBookScreen
              return BookListCard(
                book: book,
                onCardTap: () {
                  // Navigate to the Edit screen on tap
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => EditBookScreen(book: book),
                  ));
                },
                onTap: null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),

      // Floating Action Button to add a new book
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const PostBookScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
