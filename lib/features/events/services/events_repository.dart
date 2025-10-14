import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:um_connect/features/events/models/event_model.dart';

/// Handles all database operations related to events.
class EventsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches a list of upcoming events from Firestore.
  /// It only gets events where the date is in the future and limits the result to 10.
  Future<List<Event>> getUpcomingEvents() async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('date', descending: false)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching upcoming events: $e');
      return [];
    }
  }
}
