import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an announcement item.
class Announcement {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime timestamp;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.timestamp,
  });

  /// Factory constructor to create an Announcement from a Firestore document.
  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      content: data['content'] ?? '',
      category: data['category'] ?? 'General',
      timestamp: (data['date'] as Timestamp).toDate(),
    );
  }
}
