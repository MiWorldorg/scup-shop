import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/widgets/async_state_view.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/repository/post_repository_imp.dart';
import 'package:sculpture_shop/features/admin_panel/posts/presentation/controllers/posts_manage_controller.dart';
import 'package:sculpture_shop/features/admin_panel/posts/presentation/pages/post_manage_editor_dialog.dart';
import 'package:sculpture_shop/features/admin_panel/products/posts_list_card_widget.dart';

class PostManagePage extends GetView<PostsManageController> {
  @override
  final PostsManageController controller = Get.put(
    PostsManageController(repo: PostManageRepositoryImpl()),
  );

  PostManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Posts',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Obx(
                  () => IconButton.filledTonal(
                    tooltip: 'Refresh posts',
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.fetchLatestPosts,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _showEditor(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('New post'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Create, edit, publish, and manage journal stories.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.68),
              ),
            ),
            const SizedBox(height: 18),
            Obx(
              () => AsyncStateView(
                isLoading: controller.isLoading.value,
                errorMessage: controller.errorMessage.value,
                isEmpty: controller.posts.isEmpty,
                emptyMessage: 'No posts are available yet.',
                onRetry: controller.fetchLatestPosts,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.posts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final post = controller.posts[index];
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: PostsListCard(
                        post: post,
                        onEdit: () => _showEditor(context, post),
                        onTogglePublished: () => _togglePublished(post),
                        onDelete: () => _confirmDelete(context, post),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Previous page',
                    onPressed: controller.currentPage.value <= 1 ||
                            controller.isLoading.value
                        ? null
                        : () => controller.goToPage(
                            controller.currentPage.value - 1,
                          ),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Text(
                    'Page ${controller.currentPage.value} of ${controller.lastPage.value}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  IconButton(
                    tooltip: 'Next page',
                    onPressed: controller.currentPage.value >=
                                controller.lastPage.value ||
                            controller.isLoading.value
                        ? null
                        : () => controller.goToPage(
                            controller.currentPage.value + 1,
                          ),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditor(
    BuildContext context, [
    PostManageResponse? post,
  ]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => PostManageEditorDialog(post: post),
    );
    if (saved == true) {
      Get.snackbar(
        post == null ? 'Post created' : 'Post updated',
        'The journal has been refreshed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _togglePublished(PostManageResponse post) async {
    try {
      await controller.setPublished(post, !post.isPublished);
      Get.snackbar(
        post.isPublished ? 'Post unpublished' : 'Post published',
        'The post visibility has been updated.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Could not update post',
        ApiResponse.userFacingError(error),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    PostManageResponse post,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete post?'),
        content: Text('Delete “${post.title}”? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    try {
      await controller.deletePost(post.id);
      Get.snackbar(
        'Post deleted',
        'The post has been removed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Could not delete post',
        ApiResponse.userFacingError(error),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
