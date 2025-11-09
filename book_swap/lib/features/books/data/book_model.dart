import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String condition; // 'New', 'Like New', 'Good', 'Used'
  final String coverImageUrl;
  final String ownerId;
  final String ownerEmail;
  final String status; // 'available' or 'pending'
  final String? requesterId; // User who wants to swap

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    required this.coverImageUrl,
    required this.ownerId,
    required this.ownerEmail,
    this.status = 'available',
    this.requesterId,
  });

  // Method to convert a Book object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'condition': condition,
      'coverImageUrl': coverImageUrl,
      'ownerId': ownerId,
      'ownerEmail': ownerEmail,
      'status': status,
      'requesterId': requesterId,
    };
  }

  // Factory constructor to create a Book from a Firestore DocumentSnapshot
  factory Book.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      condition: data['condition'] ?? '',
      coverImageUrl: data['coverImageUrl'] ?? '',
      ownerId: data['ownerId'] ?? '',
      ownerEmail: data['ownerEmail'] ?? '',
      status: data['status'] ?? 'available',
      requesterId: data['requesterId'],
    );
  }
}

// Add copyWith extension for easy updates
extension BookCopyWith on Book {
  Book copyWith({
    String? title,
    String? author,
    String? condition,
    String? coverImageUrl,
    String? ownerId,
    String? ownerEmail,
    String? status,
    String? requesterId,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      condition: condition ?? this.condition,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      ownerId: ownerId ?? this.ownerId,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      status: status ?? this.status,
      requesterId: requesterId ?? this.requesterId,
    );
  }
}
