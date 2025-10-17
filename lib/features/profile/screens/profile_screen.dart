import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:um_connect/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(authStateChangesProvider);
    final user = userAsyncValue.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
              children: [
                // --- User Header ---
                Card(
                  // This card has a local style override for a different look
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.black12,
                          child: Icon(
                            Icons.person_outline,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.email ?? 'No email available',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Student', // Placeholder for user role
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Menu Options ---
                _buildSectionHeader(context, 'Account'),
                Card(
                  // Styling is now inherited from AppTheme
                  child: Column(
                    children: [
                      _buildProfileMenuOption(
                        icon: Icons.edit_outlined,
                        title: 'Edit Profile',
                        onTap: () {},
                      ),
                      _buildProfileMenuOption(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {
                          context.go('/home/settings');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Support'),
                Card(
                  // Styling is now inherited from AppTheme
                  child: Column(
                    children: [
                      _buildProfileMenuOption(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {},
                      ),
                      _buildProfileMenuOption(
                        icon: Icons.info_outline,
                        title: 'About App',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  onPressed: () {
                    ref.read(authRepositoryProvider).signOut();
                  },
                  // No style needed; it inherits from OutlinedButtonThemeData
                ),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }

  Widget _buildProfileMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    // ListTile now inherits its icon color from the global theme
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
