import 'package:accordion/accordion.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/constants/routes.dart';
import 'package:sculpture_shop/core/widgets/async_state_view.dart';
import 'package:sculpture_shop/core/widgets/header.dart';
import 'package:sculpture_shop/core/widgets/sections_header.dart';
import 'package:sculpture_shop/core/widgets/website_drawer_mobile.dart';
import 'package:sculpture_shop/core/widgets/website_footer.dart';
import 'package:sculpture_shop/features/public/blog/data/repository/post_repository_imp.dart';
import 'package:sculpture_shop/features/public/blog/presentation/controllers/post_controller.dart';
import 'package:sculpture_shop/features/public/blog/presentation/pages/blog-posts-tile.dart';
import 'package:sculpture_shop/features/public/blog/presentation/widgets/post_card_widget.dart';
import 'package:sculpture_shop/features/public/landing_page/presentation/widgets/features_cart_item.dart';
import 'package:sculpture_shop/features/public/landing_page/presentation/widgets/slider_products_banner_widget.dart';
import 'package:sculpture_shop/features/public/shop/data/repository/shop_repository_imp.dart';
import 'package:sculpture_shop/features/public/shop/presentation/controllers/shop_controller.dart';
import 'package:sculpture_shop/features/public/shop/presentation/pages/shop-products-tile.dart';
import 'package:sculpture_shop/features/public/shop/presentation/widgets/product_card_widget.dart';

import '../controllers/landing_controller.dart';

class LandingPage extends GetView<LandingController> {
  final ShopController shopController = Get.put(
    ShopController(repo: ShopRepositoryImpl()),
  );
  final PostController postController = Get.put(
    PostController(repo: PostRepositoryImpl()),
  );
  LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        drawer: MobileDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: getResponsivePadding(context, screenWidth),
            child: SafeArea(
              child: Column(
                children: [
                  FadeIn(child: Header(selectedIndex: 0.obs)),
                  const SizedBox(height: 32),
                  FadeIn(
                    delay: const Duration(milliseconds: 500),
                    child: SizedBox(
                      height: isMobile ? 390 : 500,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/Landing-page-bg.png',
                              fit: BoxFit.cover,
                            ),
                            const SliderBanner(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeIn(
                    delay: const Duration(milliseconds: 1000),
                    child: Container(
                      height: isMobile ? 760 : 480,
                      padding: EdgeInsets.all(isMobile ? 10 : 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.onBackground.withOpacity(0.07),
                        ),
                      ),
                      child: ResponsiveRowColumn(
                        columnMainAxisAlignment: MainAxisAlignment.center,
                        columnSpacing: 32,
                        rowSpacing: 32,
                        rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                        layout:
                            ResponsiveBreakpoints.of(
                              context,
                            ).smallerOrEqualTo(TABLET)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        children: [
                          ResponsiveRowColumnItem(
                            rowFlex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(isMobile ? 16 : 36),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'A closer look at quality',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          fontSize: isMobile ? 30 : 40,
                                        ),
                                  ),
                                  Text(
                                    'Our sculpture shop celebrates quality, beauty, and skilled craftsmanship. The collection features ceramic, wood, metal, and other materials, with carefully finished details that reflect the character of each piece. It is a place for art lovers to discover sculptures made with care and a strong sense of design.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.76),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ResponsiveRowColumnItem(
                            rowFlex: 1,
                            child: Image.asset(
                              'assets/images/sculpture-object.png',
                              height: isMobile ? 270 : 360,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeIn(
                    delay: const Duration(milliseconds: 1500),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 280,
                            mainAxisExtent: 104,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: 4,
                      itemBuilder: (context, index) => const [
                        FeaturesCartItem(
                          icon: Ionicons.time,
                          title: 'Fast delivery',
                        ),
                        FeaturesCartItem(
                          icon: Ionicons.help,
                          title: '24-hour support',
                        ),
                        FeaturesCartItem(
                          icon: Ionicons.star,
                          title: 'Quality guaranteed',
                        ),
                        FeaturesCartItem(
                          icon: Ionicons.barcode,
                          title: 'A wide selection',
                        ),
                      ][index],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeIn(
                    delay: const Duration(milliseconds: 2000),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SectionsHeader(title: 'Our products'),
                        const SizedBox(height: 8),
                        Obx(
                          () => AsyncStateView(
                            isLoading: shopController.isLoading.value,
                            errorMessage: shopController.errorMessage.value,
                            isEmpty: shopController.products.isEmpty,
                            emptyMessage: 'New pieces will appear here soon.',
                            onRetry: shopController.fetchLatestProduct,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 310,
                                    mainAxisExtent: 412,
                                    crossAxisSpacing: 18,
                                    mainAxisSpacing: 18,
                                  ),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: shopController.products.length,
                              itemBuilder: (context, index) {
                                final product = shopController.products[index];
                                return ProductCart(
                                  productModel: product,
                                  page: ShopProductsTile(product: product),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeIn(
                    delay: const Duration(milliseconds: 2500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SectionsHeader(title: 'Our articles'),
                        const SizedBox(height: 8),
                        Obx(
                          () => AsyncStateView(
                            isLoading: postController.isLoading.value,
                            errorMessage: postController.errorMessage.value,
                            isEmpty: postController.posts.isEmpty,
                            emptyMessage: 'New stories will appear here soon.',
                            onRetry: postController.fetchLatestPosts,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 330,
                                    mainAxisExtent: 390,
                                    crossAxisSpacing: 18,
                                    mainAxisSpacing: 18,
                                  ),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: postController.posts.length,
                              itemBuilder: (context, index) {
                                final post = postController.posts[index];
                                return PostCard(
                                  post: post,
                                  page: BlogPostsTile(post: post),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeIn(
                    delay: const Duration(milliseconds: 3000),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SectionsHeader(
                          title: 'Frequently asked questions',
                        ),
                        const SizedBox(height: 8),
                        Accordion(
                          contentBackgroundColor: Theme.of(
                            context,
                          ).cardColor.withOpacity(0.8),
                          headerPadding: const EdgeInsets.all(24),
                          headerBackgroundColor: Theme.of(context).cardColor,
                          children: [
                            AccordionSection(
                              header: const Text('1. Why shop with us?'),
                              content: const Text(
                                'With more than 10 years of experience selling sculptures, we have earned the trust of customers across the country. Our focus has always been to improve the quality of our work.',
                              ),
                            ),
                            AccordionSection(
                              header: const Text(
                                '2. What materials are the sculptures made from?',
                              ),
                              content: const Text(
                                'We aim to offer pieces worthy of our customers, using quality ceramic, metal, wood, and stone.',
                              ),
                            ),
                            AccordionSection(
                              header: const Text(
                                '3. How long does delivery take?',
                              ),
                              content: const Text(
                                'Orders placed during business hours are packed and shipped the same day. Orders placed later are prepared on the next business day.',
                              ),
                            ),
                            AccordionSection(
                              header: const Text(
                                '4. How are orders delivered?',
                              ),
                              content: const Text(
                                'In Tehran, choose the shop’s courier for delivery in under 24 hours. For other cities, express post usually takes 3–5 business days.',
                              ),
                            ),
                            AccordionSection(
                              header: const Text(
                                '5. What should I do if an item is damaged during delivery?',
                              ),
                              content: const Text(
                                'We pack each item carefully to reduce the risk of damage. If an item arrives damaged, contact the shop’s support team to arrange a return and replacement.',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeIn(
                    delay: const Duration(milliseconds: 3500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SectionsHeader(
                          title: 'Have a suggestion? Share it with us.',
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runSpacing: 16,
                            spacing: 20,
                            children: [
                              const Text(
                                'Questions or suggestions? We’re here to help.',
                              ),
                              FilledButton.icon(
                                onPressed: () =>
                                    Get.toNamed(AppRoutes.contactUs),
                                icon: const Icon(
                                  Ionicons.chatbubble_ellipses_outline,
                                ),
                                label: const Text('Contact us'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Footer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
