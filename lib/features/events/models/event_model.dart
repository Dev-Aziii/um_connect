import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime date;
  final String venue;

  Event({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.venue,
  });

  /// Factory constructor to create an Event from a Firestore document.
  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'],
      imageUrl: data['imageUrl'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      venue: data['venue'] ?? 'No Venue',
    );
  }
}
