import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/features/events/models/event_model.dart';
import 'package:um_connect/features/events/services/events_repository.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return EventsRepository();
});

final upcomingEventsProvider = FutureProvider<List<Event>>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return repository.getUpcomingEvents();
});

// --- NEW PROVIDER ---
// A FutureProvider.family is used when you need to pass an argument (the eventId)
// to your provider to fetch specific data.
final eventByIdProvider = FutureProvider.family<Event, String>((ref, eventId) {
  final repository = ref.watch(eventsRepositoryProvider);
  return repository.getEventById(eventId);
});
