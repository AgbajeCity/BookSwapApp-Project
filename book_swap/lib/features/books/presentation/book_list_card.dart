import 'package:flutter/material.dart';
import '../data/book_model.dart';

class BookListCard extends StatelessWidget {
  const BookListCard({
    super.key,
    required this.book,
    this.onTap, // Used for the "Swap" button on Browse Screen
    this.onCardTap, // Used for the Card tap gesture (e.g., Edit Listing)
  });

  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Wrap the card in a GestureDetector for the edit/details view
    return GestureDetector(
      onTap: onCardTap,
      child: Card(
        color: theme.colorScheme.surface.withAlpha(25),
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Book Cover Image ---
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  book.coverImageUrl,
                  width: 60, // Smaller width for cleaner list
                  height: 90, // Adjusted height
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 60,
                      height: 90,
                      color: Colors.grey[800],
                      child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              // --- Book Details ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16), // SemiBold Poppins
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by ${book.author}',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontSize: 12), // Finer author text
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // --- Condition Chip ---
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(51),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        book.condition,
                        style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Swap/Action Button ---
              if (onTap != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: Size.zero, // Make button minimal
                    ),
                    child: const Text('Swap',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
