import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/features/home/widgets/latest_announcements_list.dart';
import 'package:um_connect/features/home/widgets/upcoming_events_carousel.dart';
import 'package:um_connect/providers/announcements_provider.dart';
import 'package:um_connect/providers/auth_provider.dart';
import 'package:um_connect/providers/events_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final displayName = user?.email?.split('@')[0] ?? 'User';

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          // Invalidate providers to refetch data on pull-to-refresh
          ref.invalidate(upcomingEventsProvider);
          ref.invalidate(recentAnnouncementsProvider);
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // --- Enhanced Greeting Section ---
            _buildGreetingCard(context, displayName),
            const SizedBox(height: 24),

            // --- Quick Actions Section ---
            _buildSectionHeader(
              context,
              icon: Icons.widgets_outlined,
              title: 'Quick Actions',
              hasViewAll: false,
            ),
            const SizedBox(height: 12),
            _buildQuickActions(context),
            const SizedBox(height: 24),

            // --- Upcoming Events Section ---
            _buildSectionHeader(
              context,
              icon: Icons.celebration_outlined,
              title: 'Upcoming Events',
              onTap: () {
                // TODO: Navigate to the full events list screen
              },
            ),
            const SizedBox(height: 12),
            // The outer Card has been removed from here
            const UpcomingEventsCarousel(),
            const SizedBox(height: 24),

            // --- Latest Announcements Section ---
            _buildSectionHeader(
              context,
              icon: Icons.campaign_outlined,
              title: 'Latest Announcements',
              onTap: () {
                // TODO: Navigate to the full announcements list screen
              },
            ),
            const SizedBox(height: 12),
            // The outer Card has been removed from here
            const LatestAnnouncementsList(),
          ],
        ),
      ),
    );
  }

  // Helper widget for the enhanced greeting card.
  Widget _buildGreetingCard(BuildContext context, String displayName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $displayName!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Welcome to your campus hub.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: 28, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Helper widget for the quick action buttons grid.
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickActionButton(
          icon: Icons.map_outlined,
          label: 'Campus Map',
          onTap: () {
            // TODO: Implement Campus Map functionality
          },
        ),
        _QuickActionButton(
          icon: Icons.calendar_today_outlined,
          label: 'Schedule',
          onTap: () {
            // TODO: Implement Schedule functionality
          },
        ),
        _QuickActionButton(
          icon: Icons.grade_outlined,
          label: 'Grades',
          onTap: () {
            // TODO: Implement Grades functionality
          },
        ),
      ],
    );
  }

  // Helper widget for creating consistent section headers.
  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool hasViewAll = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (hasViewAll)
          TextButton(
            onPressed: onTap,
            child: Text(
              'View all',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

// A reusable widget for the individual quick action buttons.
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          margin: const EdgeInsets.symmetric(horizontal: 4),
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
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
