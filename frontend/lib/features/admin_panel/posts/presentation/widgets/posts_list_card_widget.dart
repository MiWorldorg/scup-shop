import 'package:flutter/material.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';

class PostsListCard extends StatelessWidget {
  final PostManageResponse post;
  final VoidCallback onEdit;
  final VoidCallback onTogglePublished;
  final VoidCallback onDelete;

  const PostsListCard({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onTogglePublished,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.onSurface.withOpacity(0.08)),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.article_outlined, color: colors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Category ${post.categoryId}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurface.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      post.isPublished ? 'Published' : 'Draft',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: post.isPublished ? colors.primary : colors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      post.slug,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colors.secondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            tooltip: 'Post actions',
            onSelected: (action) {
              if (action == 'edit') onEdit();
              if (action == 'visibility') onTogglePublished();
              if (action == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 12),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'visibility',
                child: Row(
                  children: [
                    Icon(
                      post.isPublished
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    const SizedBox(width: 12),
                    Text(post.isPublished ? 'Unpublish' : 'Publish'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, color: colors.error),
                    const SizedBox(width: 12),
                    Text('Delete', style: TextStyle(color: colors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
