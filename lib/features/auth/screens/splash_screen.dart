import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:um_connect/providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        // Short delay before navigation
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (context.mounted) {
            if (user != null) {
              context.go('/home');
            } else {
              context.go('/login');
            }
          }
        });

        return _buildSplashUI(context);
      },
      loading: () => _buildSplashUI(context),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('An error occurred: $err'))),
    );
  }

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
            // Lottie loading animation
            Lottie.asset(
              'assets/animations/Connecting.json',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
