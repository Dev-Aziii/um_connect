import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This notifier will hold the current theme mode (light or dark).
class ThemeNotifier extends StateNotifier<ThemeMode> {
  // Initialize with the light theme by default.
  ThemeNotifier() : super(ThemeMode.light);

  // Method to toggle between light and dark themes.
  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    // TODO: Add logic here to save the theme preference to the device (e.g., using SharedPreferences).
  }
}

// The provider that our UI will interact with.
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
