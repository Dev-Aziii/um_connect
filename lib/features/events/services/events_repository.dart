import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:um_connect/features/events/models/event_model.dart';

class EventsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<List<Event>> getAllUpcomingEvents() async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('date', descending: false)
          .get();
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching all upcoming events: $e');
      return [];
    }
  }

  Future<Event> getEventById(String eventId) async {
    try {
      final doc = await _firestore.collection('events').doc(eventId).get();
      return Event.fromFirestore(doc);
    } catch (e) {
      print('Error fetching event by ID: $e');
      rethrow;
    }
  }

  // --- NEW METHOD ---
  /// Adds a new event document to the 'events' collection in Firestore.
  Future<void> createEvent({
    required String title,
    required String detail,
    required String venue,
    required DateTime date,
    required String imageUrl,
  }) async {
    try {
      await _firestore.collection('events').add({
        'title': title,
        'detail': detail,
        'venue': venue,
        'date': Timestamp.fromDate(date),
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Error creating event: $e');
      rethrow; // Rethrow to be caught by the UI
    }
  }
}
