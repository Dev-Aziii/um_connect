import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:um_connect/providers/events_provider.dart';

class UpcomingEventsCarousel extends ConsumerWidget {
  const UpcomingEventsCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsyncValue = ref.watch(upcomingEventsProvider);

    return eventsAsyncValue.when(
      data: (events) {
        if (events.isEmpty) {
          return const Center(child: Text('No upcoming events.'));
        }
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: const EdgeInsets.only(right: 16.0),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Image
                      Expanded(
                        child: Container(
                          color: Colors.grey.shade300,
                          child: event.imageUrl.isNotEmpty
                              ? Image.network(
                                  event.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                )
                              : const Icon(Icons.event),
                        ),
                      ),
                      // Event Details
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.venue,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              // Format the date nicely using the intl package
                              DateFormat.yMMMd().add_jm().format(event.date),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          const Center(child: Text('Could not load events.')),
    );
  }
}
