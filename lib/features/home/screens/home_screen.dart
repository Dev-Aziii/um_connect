import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/providers/auth_provider.dart';

// We change this to a `ConsumerWidget` so we can access Riverpod's `ref`.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        // Add an actions list for buttons on the right side of the app bar.
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Read the repository from the provider and call the signOut method.
              ref.read(authRepositoryProvider).signOut();
              // After this runs, the authStateChangesProvider will emit `null`,
              // and the logic in SplashScreen will automatically navigate back to /login.
            },
          ),
        ],
      ),
      body: const Center(child: Text('Welcome! You are logged in.')),
    );
  }
}
