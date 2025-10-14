import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:um_connect/features/auth/screens/login_screen.dart';
import 'package:um_connect/features/auth/screens/splash_screen.dart';
import 'package:um_connect/features/home/screens/home_screen.dart';
import 'package:um_connect/providers/auth_provider.dart';

// We create a provider for our router so it can access other providers (like authStateChangesProvider).
final goRouterProvider = Provider<GoRouter>((ref) {
  // The router now watches the authentication state.
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
    // This redirect function is the core of the fix.
    // It runs before every navigation event.
    redirect: (context, state) {
      // While we're checking the auth status, don't redirect.
      // This allows the splash screen to display.
      if (authState.isLoading || authState.hasError) {
        return null;
      }

      // Check if the user is logged in by seeing if the user object from Firebase exists.
      final isLoggedIn = authState.valueOrNull != null;

      // Check if the user's current destination is the login screen.
      final isGoingToLogin = state.matchedLocation == '/login';

      // --- THE REDIRECTION RULES ---

      // Rule 1: If the user is NOT logged in and is trying to go anywhere
      // other than the login screen, force them to the login screen.
      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }

      // Rule 2: If the user IS logged in but is somehow trying to go
      // to the login screen, send them to the home screen instead.
      if (isLoggedIn && isGoingToLogin) {
        return '/home';
      }

      // Rule 3: If none of the above rules apply, do nothing.
      // Let the user go where they intended.
      return null;
    },
  );
});
