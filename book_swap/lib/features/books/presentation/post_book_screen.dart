import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/book_controller.dart';

class PostBookScreen extends ConsumerStatefulWidget {
  const PostBookScreen({super.key});

  @override
  ConsumerState<PostBookScreen> createState() => _PostBookScreenState();
}

class _PostBookScreenState extends ConsumerState<PostBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  String _condition = 'New'; // Default value

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      // Call the controller to post the book
      ref.read(bookControllerProvider.notifier).postBook(
            title: _titleController.text,
            author: _authorController.text,
            condition: _condition,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for loading/error states
    ref.listen<AsyncValue<void>>(bookControllerProvider, (_, state) {
      if (state.isLoading) {
        // You could show a loading dialog here
      } else if (state.hasError) {
        // Show an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error.toString())),
        );
      } else if (state.hasValue && !state.isLoading) {
        // Success! Pop the screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book posted successfully!')),
        );
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      }
    });

    final bookState = ref.watch(bookControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Book'),
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
              RadioListTile<String>(
                title: const Text('New'),
                value: 'New',
                groupValue: _condition,
                onChanged: (val) => setState(() => _condition = val!),
              ),
              RadioListTile<String>(
                title: const Text('Like New'),
                value: 'Like New',
                groupValue: _condition,
                onChanged: (val) => setState(() => _condition = val!),
              ),
              RadioListTile<String>(
                title: const Text('Good'),
                value: 'Good',
                groupValue: _condition,
                onChanged: (val) => setState(() => _condition = val!),
              ),
              RadioListTile<String>(
                title: const Text('Used'),
                value: 'Used',
                groupValue: _condition,
                onChanged: (val) => setState(() => _condition = val!),
              ),
              const SizedBox(height: 24),
              Text(
                'Note: A placeholder image will be used.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 24),
              bookState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitPost,
                      child: const Text('Post Book'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
