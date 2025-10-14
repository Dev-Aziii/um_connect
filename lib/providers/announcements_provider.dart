import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/features/announcements/models/announcement_model.dart';
import 'package:um_connect/features/announcements/services/announcements_repository.dart';

// Provider for the AnnouncementsRepository.
final announcementsRepositoryProvider = Provider<AnnouncementsRepository>((
  ref,
) {
  return AnnouncementsRepository();
});

// FutureProvider to fetch the list of recent announcements.
final recentAnnouncementsProvider = FutureProvider<List<Announcement>>((ref) {
  final repository = ref.watch(announcementsRepositoryProvider);
  return repository.getRecentAnnouncements();
});
