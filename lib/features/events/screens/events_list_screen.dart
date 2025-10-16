import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:um_connect/features/events/models/event_model.dart';
import 'package:um_connect/providers/events_provider.dart';
import 'package:um_connect/providers/user_provider.dart';

class EventsListScreen extends ConsumerWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEventsAsyncValue = ref.watch(allUpcomingEventsProvider);
    final userProfile = ref.watch(userProfileProvider);
    final userRole = userProfile.value?.role;

    return Scaffold(
      appBar: AppBar(title: const Text('All Events')),
      body: allEventsAsyncValue.when(
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text('No upcoming events found.'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(allUpcomingEventsProvider);
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return _EventListTile(event: event);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Could not load events: $err')),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: (userRole == 'CSG' || userRole == 'Faculty')
          ? Padding(
              padding: const EdgeInsets.only(
                bottom: 70.0,
              ), 
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.go('/home/create-event');
                },
                label: const Text('Create Event'),
                icon: const Icon(Icons.add),
                backgroundColor: Colors.white.withOpacity(0.6),
              ),
            )
          : null,
    );
  }
}

class _EventListTile extends StatelessWidget {
  final Event event;
  const _EventListTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/home/event/${event.id}'),
        child: Row(
          children: [
            Image.network(
              event.imageUrl,
              width: 110,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 110,
                height: 130,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      text: DateFormat.yMMMd().format(event.date),
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on_outlined,
                      text: event.venue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
