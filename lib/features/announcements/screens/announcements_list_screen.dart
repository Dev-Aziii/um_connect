import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:um_connect/providers/announcements_provider.dart';
import 'package:um_connect/providers/user_provider.dart';
import 'package:um_connect/shared_widgets/post_card.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsyncValue = ref.watch(recentAnnouncementsProvider);
    final userProfile = ref.watch(userProfileProvider);
    final userRole = userProfile.value?.role;
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;

    return announcementsAsyncValue.when(
      data: (announcements) {
        if (announcements.isEmpty) {
          return const Center(child: Text('No announcements found.'));
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(recentAnnouncementsProvider),
          child: Stack(
            children: [
              ListView.builder(
                padding: EdgeInsets.fromLTRB(8.0, topPadding + 8.0, 8.0, 120.0),
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return PostCard(
                    category: announcement.category.toUpperCase(),
                    categoryIcon: _getIconForCategory(announcement.category),
                    title: announcement.title,
                    footerContent: _buildAnnouncementFooter(
                      context,
                      announcement.date,
                    ),
                    onTap: () =>
                        context.go('/home/announcement/${announcement.id}'),
                  );
                },
              ),
              if (userRole == 'CSG' || userRole == 'Faculty')
                Positioned(
                  bottom: 90,
                  right: 16,
                  child: FloatingActionButton.extended(
                    onPressed: () => context.go('/home/create-announcement'),
                    label: const Text('Create Post'),
                    icon: const Icon(Icons.add),
                    // No local styling needed; inherits from theme
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          Center(child: Text('Could not load announcements: $err')),
    );
  }

  Widget _buildAnnouncementFooter(BuildContext context, DateTime date) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 14,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 6),
        Text(
          'Posted on ${DateFormat.yMMMd().format(date)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
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
