import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:um_connect/core/models/user_model.dart';
import 'package:um_connect/features/profile/services/user_repository.dart';
import 'package:um_connect/providers/auth_provider.dart';

// 1. Provider for the UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

// 2. This is the main provider our UI will use.
// It watches the authentication state. When a user logs in, it uses their UID
// to fetch their detailed profile from the UserRepository.
final userProfileProvider = FutureProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  // If a user is logged in, fetch their profile. Otherwise, return null.
  final uid = authState.valueOrNull?.uid;
  if (uid != null) {
    return userRepository.getUserProfile(uid);
  }
  return null;
});
