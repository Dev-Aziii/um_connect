import 'package:flutter/material.dart';

/// A reusable card widget to display content in a feed, similar to a Reddit post.
class PostCard extends StatelessWidget {
  final String category;
  final IconData categoryIcon;
  final String title;
  final Widget? bodyContent;
  final Widget footerContent;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.category,
    required this.categoryIcon,
    required this.title,
    this.bodyContent,
    required this.footerContent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Card Header ---
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  Icon(categoryIcon, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // --- Card Title ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // --- Optional Body Content (like an image) ---
            if (bodyContent != null) ...[
              const SizedBox(height: 12),
              bodyContent!,
            ],
            // --- Card Footer ---
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: footerContent,
            ),
          ],
        ),
      ),
    );
  }
}
