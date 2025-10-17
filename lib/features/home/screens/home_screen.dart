import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:um_connect/features/home/widgets/upcoming_events_carousel.dart';
import 'package:um_connect/providers/announcements_provider.dart';
import 'package:um_connect/providers/events_provider.dart';
import 'package:um_connect/shared_widgets/post_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final announcementsAsync = ref.watch(recentAnnouncementsProvider);
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;

    // A single loading state for the whole screen
    if (eventsAsync.isLoading || announcementsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // A single error state
    if (eventsAsync.hasError || announcementsAsync.hasError) {
      return const Center(child: Text('Could not load feed.'));
    }

    // Get the data now that we know it's available
    final announcements = announcementsAsync.value ?? [];

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(upcomingEventsProvider);
        ref.invalidate(recentAnnouncementsProvider);
      },
      child: ListView(
        padding: EdgeInsets.fromLTRB(8.0, topPadding + 8.0, 8.0, 100.0),
        children: [
          _buildSectionHeader(context, 'Upcoming Events'),
          const SizedBox(height: 12),
          const UpcomingEventsCarousel(),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Recent Announcements'),
          const SizedBox(height: 12),
          // Check if announcements list is empty
          if (announcements.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No recent announcements.'),
              ),
            )
          else
            // Build the list of PostCards for announcements
            ...announcements.map((announcement) {
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
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
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
