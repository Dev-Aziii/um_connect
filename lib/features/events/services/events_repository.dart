import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:um_connect/features/events/models/event_model.dart';

class EventsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches a limited list of upcoming events for the home screen.
  Future<List<Event>> getUpcomingEvents() async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('date', descending: false)
          .limit(10) // Limits to 10 for the home screen carousel
          .get();

      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching upcoming events: $e');
      return [];
    }
  }

  // --- NEW METHOD ---
  /// Fetches a full, unlimited list of all upcoming events.
  Future<List<Event>> getAllUpcomingEvents() async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('date', descending: false) // No limit, gets all documents
          .get();

      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching all upcoming events: $e');
      return [];
    }
  }

  /// Fetches a single event document by its ID.
  Future<Event> getEventById(String eventId) async {
    try {
      final doc = await _firestore.collection('events').doc(eventId).get();
      return Event.fromFirestore(doc);
    } catch (e) {
      print('Error fetching event by ID: $e');
      rethrow;
    }
  }
}
