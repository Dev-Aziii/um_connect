import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:um_connect/features/announcements/screens/announcement_detail_screen.dart';
import 'package:um_connect/features/auth/screens/login_screen.dart';
import 'package:um_connect/features/auth/screens/splash_screen.dart';
import 'package:um_connect/features/events/screens/event_detail_screen.dart';
import 'package:um_connect/features/home/screens/main_nav_screen.dart';
import 'package:um_connect/features/settings/screens/settings_screen.dart';
import 'package:um_connect/providers/auth_provider.dart';
import 'package:um_connect/features/events/screens/create_event_screen.dart';
import 'package:um_connect/features/announcements/screens/create_announcement_screen.dart';

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
        builder: (context, state) => const MainNavScreen(),
        routes: [
          GoRoute(
            path: 'event/:id',
            builder: (context, state) {
              final eventId = state.pathParameters['id']!;
              return EventDetailScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: 'announcement/:id',
            builder: (context, state) {
              final announcementId = state.pathParameters['id']!;
              return AnnouncementDetailScreen(announcementId: announcementId);
            },
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          // --- NEW ROUTES ---
          GoRoute(
            path: 'create-event',
            builder: (context, state) => const CreateEventScreen(),
          ),
          GoRoute(
            path: 'create-announcement',
            builder: (context, state) => const CreateAnnouncementScreen(),
          ),
        ],
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
