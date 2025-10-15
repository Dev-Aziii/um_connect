import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // The logout button is now located on the profile page.
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement a confirmation dialog before logging out.
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: const Center(
        // TODO: Display user information (name, email, student ID).
        // TODO: Add settings options (e.g., notification preferences).
        child: Text('This screen will show user profile and settings.'),
      ),
    );
  }
}
