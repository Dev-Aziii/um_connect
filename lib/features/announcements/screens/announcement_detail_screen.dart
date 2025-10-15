import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:um_connect/providers/announcements_provider.dart';

class AnnouncementDetailScreen extends ConsumerWidget {
  final String announcementId;
  const AnnouncementDetailScreen({super.key, required this.announcementId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementAsyncValue = ref.watch(
      announcementByIdProvider(announcementId),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Announcement'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: announcementAsyncValue.when(
        data: (announcement) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and Date
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                      child: Icon(
                        _getIconForCategory(announcement.category),
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Posted on ${DateFormat.yMMMMd().format(announcement.date)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  announcement.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 32, thickness: 1.5),
                // Content
                Text(
                  announcement.content,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Icons.school_outlined;
      case 'holiday':
        return Icons.celebration_outlined;
      case 'safety':
        return Icons.security_outlined;
      default:
        return Icons.campaign_outlined;
    }
  }
}
