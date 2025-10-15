import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:um_connect/features/announcements/models/announcement_model.dart';

class AnnouncementsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Announcement>> getRecentAnnouncements() async {
    try {
      final snapshot = await _firestore
          .collection('announcements')
          .orderBy('date', descending: true)
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

  // --- NEW METHOD ---
  /// Fetches a single announcement document by its ID.
  Future<Announcement> getAnnouncementById(String announcementId) async {
    try {
      final doc = await _firestore
          .collection('announcements')
          .doc(announcementId)
          .get();
      return Announcement.fromFirestore(doc);
    } catch (e) {
      print('Error fetching announcement by ID: $e');
      rethrow; // Rethrow to be handled by the provider
    }
  }
}
