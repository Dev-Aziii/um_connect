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

  // --- NEW METHOD ---
  // Fetches a single event document by its ID.
  Future<Event> getEventById(String eventId) async {
    try {
      final doc = await _firestore.collection('events').doc(eventId).get();
      return Event.fromFirestore(doc);
    } catch (e) {
      print('Error fetching event by ID: $e');
      rethrow; // Rethrow the error to be handled by the provider
    }
  }
}
