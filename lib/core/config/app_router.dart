import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:um_connect/features/auth/screens/login_screen.dart';
import 'package:um_connect/features/auth/screens/splash_screen.dart';
// Import the new main navigation screen
import 'package:um_connect/features/home/screens/main_nav_screen.dart';
import 'package:um_connect/providers/auth_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/home',
        // The '/home' route now points to our new MainNavScreen.
        builder: (context, state) => const MainNavScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isGoingToLogin = state.matchedLocation == '/login';

      if (authState.isLoading || authState.hasError) return null;

      if (!isLoggedIn && !isGoingToLogin) return '/login';

      if (isLoggedIn && isGoingToLogin) return '/home';

      return null;
    },
  );
});
