import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Announcements')),
      body: const Center(
        // TODO: Implement a full, filterable list of all announcements.
        child: Text('This screen will show a list of all announcements.'),
      ),
    );
  }
}
