import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:um_connect/features/announcements/models/announcement_model.dart';

/// Handles all database operations related to announcements.
class AnnouncementsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches the most recent announcements from Firestore.
  /// It orders them by timestamp and limits the result to 10.
  Future<List<Announcement>> getRecentAnnouncements() async {
    try {
      final snapshot = await _firestore
          .collection('announcements')
          .orderBy('date', descending: false)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => Announcement.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching recent announcements: $e');
      return [];
    }
  }
}
