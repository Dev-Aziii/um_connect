import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:um_connect/providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    // The `when` method is a clean way to handle the different states of an async provider.
    return authState.when(
      // The `data` callback is triggered when the stream emits a value.
      data: (user) {
        // short delay to prevent the splash screen from flashing too quickly.
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (context.mounted) {
            if (user != null) {
              context.go('/home');
            } else {
              context.go('/login');
            }
          }
        });

        // While waiting for the delay and navigation, show the splash UI.
        return _buildSplashUI(context);
      },
      // Show the splash UI while the provider is in its initial loading state.
      loading: () => _buildSplashUI(context),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('An error occurred: $err'))),
    );
  }

  // splash screen UI builder method
  Widget _buildSplashUI(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8F1E29),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/University_of_Mindanao_Logo.png',
              width: 100,
              height: 100,
              // fallback
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.school, size: 100, color: Colors.white);
              },
            ),
            const SizedBox(height: 20),
            Text(
              'UM-Connect',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
