import 'package:flutter/material.dart';

class CreateAnnouncementScreen extends StatelessWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Announcement')),
      body: const Center(
        child: Text('Announcement creation form will be here.'),
      ),
    );
  }
}
