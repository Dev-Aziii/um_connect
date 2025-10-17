import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:um_connect/core/config/app_router.dart';
import 'package:um_connect/core/theme/app_theme.dart';
import 'package:um_connect/providers/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    // Watch the theme provider to get the current theme mode
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'UM-Connect',
      // --- THEME PROPERTIES UPDATED ---
      theme: AppTheme.lightTheme, // Set the light theme
      darkTheme: AppTheme.darkTheme, // Set the dark theme
      themeMode: themeMode, // Let the provider control which theme is active
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
