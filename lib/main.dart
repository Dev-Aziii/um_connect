import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:um_connect/core/theme/app_theme.dart';
import 'package:um_connect/core/config/app_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

// MyApp must now be a ConsumerWidget to be able to "watch" providers.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We now watch the goRouterProvider to get our router configuration.
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'UM-Connect',
      theme: AppTheme.lightTheme,
      // The router configuration is passed here.
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
