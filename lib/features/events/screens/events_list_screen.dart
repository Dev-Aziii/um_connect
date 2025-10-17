import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:um_connect/providers/events_provider.dart';
import 'package:um_connect/providers/user_provider.dart';
import 'package:um_connect/shared_widgets/post_card.dart';
import 'package:intl/intl.dart';

class EventsListScreen extends ConsumerWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEventsAsyncValue = ref.watch(allUpcomingEventsProvider);
    final userProfile = ref.watch(userProfileProvider);
    final userRole = userProfile.value?.role;

    return allEventsAsyncValue.when(
      data: (events) {
        if (events.isEmpty) {
          return const Center(child: Text('No upcoming events found.'));
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(allUpcomingEventsProvider),
          child: Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 120.0),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return PostCard(
                    category: 'EVENT',
                    categoryIcon: Icons.celebration_outlined,
                    title: event.title,
                    bodyContent: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        event.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    footerContent: _buildEventFooter(
                      context,
                      event.date,
                      event.venue,
                    ),
                    onTap: () => context.go('/home/event/${event.id}'),
                  );
                },
              ),
              if (userRole == 'CSG' || userRole == 'Faculty')
                Positioned(
                  bottom: 90,
                  right: 16,
                  child: FloatingActionButton.extended(
                    onPressed: () => context.go('/home/create-event'),
                    label: const Text('Create Event'),
                    icon: const Icon(Icons.add),
                    backgroundColor: Colors.white.withOpacity(0.9),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Could not load events: $err')),
    );
  }

  Widget _buildEventFooter(BuildContext context, DateTime date, String venue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFooterItem(
          context,
          Icons.calendar_today_outlined,
          DateFormat.yMMMd().format(date),
        ),
        _buildFooterItem(context, Icons.location_on_outlined, venue),
      ],
    );
  }

  Widget _buildFooterItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
