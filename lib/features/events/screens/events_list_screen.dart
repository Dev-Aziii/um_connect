import 'package:flutter/material.dart';

class EventsListScreen extends StatelessWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Events')),
      body: const Center(
        // TODO: Implement a full, searchable list of all events.
        child: Text('This screen will show a list of all events.'),
      ),
    );
  }
}
