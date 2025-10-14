import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/features/events/models/event_model.dart';
import 'package:um_connect/features/events/services/events_repository.dart';

// Provider for the EventsRepository itself.
final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return EventsRepository();
});

// FutureProvider to fetch the list of upcoming events.
// The UI will watch this provider to get the data and handle loading/error states.
final upcomingEventsProvider = FutureProvider<List<Event>>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return repository.getUpcomingEvents();
});
