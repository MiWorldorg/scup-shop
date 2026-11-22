import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/widgets/async_state_view.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/repository/post_repository_imp.dart';
import 'package:sculpture_shop/features/admin_panel/posts/presentation/controllers/posts_manage_controller.dart';
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
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Manage the stories shown in the journal.',
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
                  itemBuilder: (context, index) => Directionality(
                    textDirection: TextDirection.ltr,
                    child: PostsListCard(post: controller.posts[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
