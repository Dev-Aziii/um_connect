import 'package:flutter/material.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Event')),
      body: const Center(child: Text('Event creation form will be here.')),
    );
  }
}
