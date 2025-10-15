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

  @override
  void initState() {
    super.initState();
    // viewportFraction controls how much of the screen each page takes up.
    // 0.85 means each page will take 85% of the screen width,
    // leaving space for the next and previous pages to peek through.
    _pageController = PageController(viewportFraction: 0.85);
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
        return SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: events.length,
            // Set clipBehavior to none to allow the peeking items to be visible.
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              // Add padding to each page to create space between the cards.
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: EventCard(event: events[index]),
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
