import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/async_state_view.dart';
import 'package:sculpture_shop/core/widgets/header.dart';
import 'package:sculpture_shop/core/widgets/website_drawer_mobile.dart';
import 'package:sculpture_shop/core/widgets/website_footer.dart';
import 'package:sculpture_shop/features/public/blog/presentation/pages/blog-posts-tile.dart';
import 'package:sculpture_shop/features/public/blog/presentation/widgets/post_card_widget.dart';

import '../controllers/post_controller.dart';

class BlogPage extends GetView<PostController> {
  BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: MobileDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: getResponsivePadding(context, width),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Header(selectedIndex: 2.obs),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: colors.primary.withOpacity(0.14)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'JOURNAL',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stories behind the art',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore sculpture, materials, and the ideas that shape each piece.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onBackground.withOpacity(0.72),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Obx(
                  () => AsyncStateView(
                    isLoading: controller.isLoading.value,
                    errorMessage: controller.errorMessage.value,
                    isEmpty: controller.posts.isEmpty,
                    emptyMessage: 'New stories will appear here soon.',
                    onRetry: controller.fetchLatestPosts,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.posts.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 340,
                            mainAxisExtent: 390,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                          ),
                      itemBuilder: (context, index) {
                        final post = controller.posts[index];
                        return PostCard(
                          post: post,
                          page: BlogPostsTile(post: post),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                const Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
