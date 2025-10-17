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

    return (eventsAsync.isLoading || announcementsAsync.isLoading)
        ? const Center(child: CircularProgressIndicator())
        : (eventsAsync.hasError || announcementsAsync.hasError)
        ? const Center(child: Text('Could not load feed.'))
        : _buildCombinedFeed(
            context,
            eventsAsync.value ?? [],
            announcementsAsync.value ?? [],
            ref,
          );
  }

  Widget _buildCombinedFeed(
    BuildContext context,
    List events,
    List announcements,
    WidgetRef ref,
  ) {
    final combinedList = [...events, ...announcements];
    combinedList.sort((a, b) => b.date.compareTo(a.date));

    if (combinedList.isEmpty) {
      return const Center(child: Text('No posts yet.'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(upcomingEventsProvider);
        ref.invalidate(recentAnnouncementsProvider);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 100.0),
        children: [
          // --- Upcoming Events Section ---
          _buildSectionHeader(context, 'Upcoming Events'),
          const SizedBox(height: 12),
          const UpcomingEventsCarousel(),
          const SizedBox(height: 24),

          // --- Recent Announcements Feed ---
          _buildSectionHeader(context, 'Recent Announcements'),
          const SizedBox(height: 12),
          ...announcements.map((announcement) {
            return PostCard(
              category: announcement.category.toUpperCase(),
              categoryIcon: _getIconForCategory(announcement.category),
              title: announcement.title,
              footerContent: _buildAnnouncementFooter(
                context,
                announcement.date,
              ),
              onTap: () => context.go('/home/announcement/${announcement.id}'),
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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildAnnouncementFooter(BuildContext context, DateTime date) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 14,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          'Posted on ${DateFormat.yMMMd().format(date)}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
