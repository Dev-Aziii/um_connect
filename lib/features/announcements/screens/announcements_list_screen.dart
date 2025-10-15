import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:um_connect/providers/announcements_provider.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsyncValue = ref.watch(recentAnnouncementsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: announcementsAsyncValue.when(
        data: (announcements) {
          if (announcements.isEmpty) {
            return const Center(child: Text('No announcements found.'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(recentAnnouncementsProvider);
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    // --- UPDATED onTap ---
                    onTap: () {
                      // Navigate to the detail screen, passing the announcement's ID
                      context.go('/home/announcement/${announcement.id}');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            child: Icon(
                              _getIconForCategory(announcement.category),
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  announcement.title,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Posted on ${DateFormat.yMMMd().format(announcement.date)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            const Center(child: Text('Could not load announcements.')),
      ),
    );
  }

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
