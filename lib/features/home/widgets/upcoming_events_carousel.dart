import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/features/events/widgets/event_card.dart';
import 'package:um_connect/providers/events_provider.dart';

// Changed to a ConsumerStatefulWidget to manage the PageController's state.
class UpcomingEventsCarousel extends ConsumerStatefulWidget {
  const UpcomingEventsCarousel({super.key});

  @override
  ConsumerState<UpcomingEventsCarousel> createState() =>
      _UpcomingEventsCarouselState();
}

class _UpcomingEventsCarouselState
    extends ConsumerState<UpcomingEventsCarousel> {
  late PageController _pageController;
  late List eventsList;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 1000, // Start somewhere in the middle for infinite feel
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsyncValue = ref.watch(upcomingEventsProvider);

    return eventsAsyncValue.when(
      data: (events) {
        if (events.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('No upcoming events.')),
          );
        }

        final itemCount = events.length;
        return SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              // Modulo to loop the items infinitely
              final currentIndex = index % itemCount;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: EventCard(event: events[currentIndex]),
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
