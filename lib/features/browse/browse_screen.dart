import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../books/application/book_controller.dart'; // Import controller for swap logic
import '../books/data/book_repository.dart';
import '../books/presentation/book_list_card.dart';
import '../books/data/book_model.dart';

// Create a StreamProvider to fetch the books
final availableBooksProvider = StreamProvider<List<Book>>((ref) {
  return ref.watch(bookRepositoryProvider).getAvailableBooks();
});

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(availableBooksProvider);

    // Listen for swap status updates
    ref.listen<AsyncValue<void>>(bookControllerProvider, (_, state) {
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error.toString())),
        );
      } else if (state.hasValue && !state.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Swap requested successfully!')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Browse Listings')),
      body: booksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return const Center(
              child: Text(
                'No books have been posted yet.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              // Check if the current user owns the book
              final isOwner =
                  ref.read(bookRepositoryProvider).currentUser?.uid ==
                      book.ownerId;

              // Only show the card if the current user does NOT own it
              if (isOwner) {
                return const SizedBox.shrink(); // Hide their own listings
              }

              return BookListCard(
                book: book,
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirm Swap'),
                          content: Text(
                              'Do you want to request a swap for "${book.title}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Request'),
                            ),
                          ],
                        ),
                      ) ??
                      false;

                  if (confirmed) {
                    ref.read(bookControllerProvider.notifier).requestSwap(book);
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error loading books: ${err.toString()}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
