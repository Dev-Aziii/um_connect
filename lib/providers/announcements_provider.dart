import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/features/announcements/models/announcement_model.dart';
import 'package:um_connect/features/announcements/services/announcements_repository.dart';

final announcementsRepositoryProvider = Provider<AnnouncementsRepository>((
  ref,
) {
  return AnnouncementsRepository();
});

final recentAnnouncementsProvider = FutureProvider<List<Announcement>>((ref) {
  final repository = ref.watch(announcementsRepositoryProvider);
  return repository.getRecentAnnouncements();
});

// --- NEW PROVIDER ---
/// A provider that fetches a single announcement by its ID.
/// The `.family` modifier allows us to pass the ID as an argument.
final announcementByIdProvider = FutureProvider.family<Announcement, String>((
  ref,
  announcementId,
) {
  final repository = ref.watch(announcementsRepositoryProvider);
  return repository.getAnnouncementById(announcementId);
});
