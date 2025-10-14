import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/features/home/widgets/latest_announcements_list.dart';
import 'package:um_connect/features/home/widgets/upcoming_events_carousel.dart';
import 'package:um_connect/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We get the current user's display name to show in the greeting.
    // In a real app, you'd fetch this from their user profile.
    final user = ref.watch(authStateChangesProvider).value;
    final displayName = user?.email?.split('@')[0] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('UM-Connect'),
        actions: [
          // The logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      // Use a ListView for scrollable content
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Greeting Section ---
          Text(
            'Hi, $displayName!',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Welcome to your campus hub.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // --- Upcoming Events Section ---
          Text(
            'Upcoming Events',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          const UpcomingEventsCarousel(), // Our custom widget for events

          const SizedBox(height: 24),

          // --- Latest Announcements Section ---
          Text(
            'Latest Announcements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          const LatestAnnouncementsList(), // Our custom widget for announcements
        ],
      ),
    );
  }
}
