// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/header.dart';
import 'package:sculpture_shop/core/widgets/website_drawer_mobile.dart';
import 'package:sculpture_shop/core/widgets/website_footer.dart';
import 'package:sculpture_shop/features/public/blog/data/entity/post_response.dart';

class BlogPostsTile extends StatelessWidget {
  final PostResponse post;

  const BlogPostsTile({required this.post, super.key});

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
                  padding: EdgeInsets.all(width < 500 ? 16 : 26),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colors.onBackground.withOpacity(0.07),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 760;
                      final image = ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: SizedBox(
                          width: double.infinity,
                          height: isWide ? 350 : 240,
                          child: Image.asset(
                            post.postPicture,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: colors.background.withOpacity(0.5),
                              child: Icon(
                                Icons.article_outlined,
                                size: 48,
                                color: colors.onBackground.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      );
                      final headline = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            post.categoryId == 1 ? 'GUIDES' : 'STORIES',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colors.primary,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            post.title,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            post.authorId == 1
                                ? 'Edited by the Sculpture Shop editorial team'
                                : 'Sculpture Shop journal',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colors.primary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.published,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colors.onBackground.withOpacity(0.56),
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            post.summary,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: colors.onBackground.withOpacity(0.78),
                                ),
                          ),
                        ],
                      );
                      if (!isWide) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            image,
                            const SizedBox(height: 22),
                            headline,
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(flex: 5, child: image),
                          const SizedBox(width: 30),
                          Expanded(flex: 6, child: headline),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: EdgeInsets.all(width < 500 ? 20 : 32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: SelectableText(
                    post.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onBackground.withOpacity(0.82),
                    ),
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
