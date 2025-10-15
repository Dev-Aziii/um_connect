import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/features/events/models/event_model.dart';
import 'package:um_connect/features/events/services/events_repository.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return EventsRepository();
});

/// Provider for the limited list of events on the home screen.
final upcomingEventsProvider = FutureProvider<List<Event>>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return repository.getUpcomingEvents();
});

// --- NEW PROVIDER ---
/// Provider for the full list of all upcoming events for the dedicated Events screen.
final allUpcomingEventsProvider = FutureProvider<List<Event>>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return repository.getAllUpcomingEvents();
});

/// Provider that fetches a single event by its ID.
final eventByIdProvider = FutureProvider.family<Event, String>((ref, eventId) {
  final repository = ref.watch(eventsRepositoryProvider);
  return repository.getEventById(eventId);
});
