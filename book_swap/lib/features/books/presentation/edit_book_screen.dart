import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/book_controller.dart';
import '../data/book_model.dart'; // This file already contains the BookCopyWith extension

class EditBookScreen extends ConsumerStatefulWidget {
  const EditBookScreen({super.key, required this.book});

  final Book book;

  @override
  ConsumerState<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends ConsumerState<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late String _condition;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing book data
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _condition = widget.book.condition;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _submitEdit() {
    if (_formKey.currentState!.validate()) {
      // Create a new Book object with updated fields (using the copyWith from book_model.dart)
      final updatedBook = widget.book.copyWith(
        title: _titleController.text,
        author: _authorController.text,
        condition: _condition,
      );

      ref.read(bookControllerProvider.notifier).editBook(updatedBook);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              ref
                  .read(bookControllerProvider.notifier)
                  .deleteListing(widget.book.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red button for Delete
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(bookControllerProvider, (_, state) {
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error.toString())),
        );
      } else if (state.hasValue && !state.isLoading) {
        // Success: pop the screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing updated successfully!')),
        );
        Navigator.of(context).pop();
      }
    });

    final bookState = ref.watch(bookControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Listing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: _confirmDelete,
            tooltip: 'Delete Listing',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Book Title'),
                validator: (val) => val!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (val) => val!.isEmpty ? 'Enter an author' : null,
              ),
              const SizedBox(height: 24),
              const Text('Condition', style: TextStyle(fontSize: 16)),
              ...['New', 'Like New', 'Good', 'Used']
                  .map((condition) => RadioListTile<String>(
                        title: Text(condition),
                        value: condition,
                        groupValue: _condition,
                        onChanged: (val) => setState(() => _condition = val!),
                      )),
              const SizedBox(height: 40),
              bookState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitEdit,
                      child: const Text('Save Changes'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
