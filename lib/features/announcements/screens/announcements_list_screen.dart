import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:um_connect/providers/announcements_provider.dart';
import 'package:um_connect/providers/user_provider.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsyncValue = ref.watch(recentAnnouncementsProvider);
    final userProfile = ref.watch(userProfileProvider);
    final userRole = userProfile.value?.role;

    return Scaffold(
      appBar: AppBar(title: const Text('All Announcements')),
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
            child: ListView.separated(
              // Apply the same padding as the Events screen to avoid overlap
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return Card(
                  elevation: 3,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      context.go('/home/announcement/${announcement.id}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 20.0,
                      ),
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Posted on ${DateFormat.yMMMd().format(announcement.date)}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Could not load announcements: $err')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: (userRole == 'CSG' || userRole == 'Faculty')
          ? Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.go('/home/create-announcement');
                },
                label: const Text('Create Post'),
                icon: const Icon(Icons.add),
                // Added a semi-transparent background to match your events screen
                backgroundColor: Colors.white.withOpacity(0.6),
              ),
            )
          : null,
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
