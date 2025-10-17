import 'package:flutter/material.dart';

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
    // This Card now inherits its style from the AppTheme
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  Icon(
                    categoryIcon,
                    size: 16,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
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
            if (bodyContent != null) ...[
              const SizedBox(height: 12),
              bodyContent!,
            ],
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
