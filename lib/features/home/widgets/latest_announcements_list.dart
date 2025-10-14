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
          return const Center(child: Text('No recent announcements.'));
        }
        // Use ListView.separated to add dividers between items
        return ListView.separated(
          shrinkWrap: true, // Important inside another scroll view
          physics: const NeverScrollableScrollPhysics(), // Let parent scroll
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return Card(
              child: ListTile(
                title: Text(announcement.title),
                subtitle: Text(
                  'Posted on ${DateFormat.yMMMd().format(announcement.timestamp)}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // To do Later, this will navigate to an announcement detail screen
                },
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          const Center(child: Text('Could not load announcements.')),
    );
  }
}
