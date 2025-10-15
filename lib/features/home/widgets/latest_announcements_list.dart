import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:um_connect/providers/announcements_provider.dart';

class LatestAnnouncementsList extends ConsumerWidget {
  const LatestAnnouncementsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsyncValue = ref.watch(recentAnnouncementsProvider);

    return announcementsAsyncValue.when(
      data: (announcements) {
        if (announcements.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: Text('No recent announcements.')),
          );
        }
        // Use ListView.builder for a dynamic list.
        return ListView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Let the parent scroll.
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return InkWell(
              onTap: () {
                // TODO: Navigate to announcement detail screen
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Category Icon
                    CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                      child: Icon(
                        _getIconForCategory(announcement.category),
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title and Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Posted on ${DateFormat.yMMMd().format(announcement.date)}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          const Center(child: Text('Could not load announcements.')),
    );
  }

  // Helper to return a specific icon based on the announcement category string.
  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Icons.school_outlined;
      case 'holiday':
        return Icons.celebration_outlined;
      case 'safety':
        return Icons.security_outlined;
      default:
        return Icons.campaign_outlined;
    }
  }
}
