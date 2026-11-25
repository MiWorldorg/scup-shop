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
import 'package:sculpture_shop/features/public/blog/presentation/controllers/post_controller.dart';
import 'package:sculpture_shop/features/public/blog/presentation/pages/blog_post_tile.dart';
import 'package:sculpture_shop/features/public/blog/presentation/widgets/post_card_widget.dart';
import 'package:sculpture_shop/features/public/landing_page/presentation/widgets/features_cart_item.dart';
import 'package:sculpture_shop/features/public/landing_page/presentation/widgets/slider_products_banner_widget.dart';
import 'package:sculpture_shop/features/public/shop/presentation/controllers/shop_controller.dart';
import 'package:sculpture_shop/features/public/shop/presentation/pages/shop_product_tile.dart';
import 'package:sculpture_shop/features/public/shop/presentation/widgets/product_card_widget.dart';

import '../controllers/landing_controller.dart';

class LandingPage extends GetView<LandingController> {
  ShopController get shopController => controller.shopController;
  PostController get postController => controller.postController;
  LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
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
                  FadeIn(animate: !reduceMotion, child: Header(selectedIndex: 0.obs)),
                  const SizedBox(height: 32),
                  FadeIn(animate: !reduceMotion, 
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
                  FadeIn(animate: !reduceMotion, 
                    delay: const Duration(milliseconds: 1000),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: isMobile ? 0 : 420),
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
                                    style: Theme.of(context).textTheme.headlineMedium
                                        ?.copyWith(
                                          fontSize: isMobile ? 28 : 36,
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
                  FadeIn(animate: !reduceMotion, 
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
                          title: 'Curated sculpture pieces',
                        ),
                        FeaturesCartItem(
                          icon: Ionicons.help,
                          title: 'Material and craft',
                        ),
                        FeaturesCartItem(
                          icon: Ionicons.star,
                          title: 'Editorial journal',
                        ),
                        FeaturesCartItem(
                          icon: Ionicons.barcode,
                          title: 'Direct studio contact',
                        ),
                      ][index],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeIn(animate: !reduceMotion, 
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
                  FadeIn(animate: !reduceMotion, 
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
                  FadeIn(animate: !reduceMotion, 
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
                              header: const Text('1. What is Scup-Shop?'),
                              content: const Text(
                                'Scup-Shop is a portfolio storefront for discovering sculpture and decorative art pieces.',
                              ),
                            ),
                            AccordionSection(
                              header: const Text(
                                '2. What can I learn about a piece?',
                              ),
                              content: const Text(
                                'Open a product detail page to explore its description, category, and listed price.',
                              ),
                            ),
                            AccordionSection(
                              header: const Text('3. Can I check out online?'),
                              content: const Text(
                                'Online checkout and payment are not part of the current portfolio release. Use the contact page to ask about a piece.',
                              ),
                            ),
                            AccordionSection(
                              header: const Text('4. What is the journal about?'),
                              content: const Text(
                                'The journal explores sculpture, materials, craft, and ideas behind visual art.',
                              ),
                            ),
                            AccordionSection(
                              header: const Text('5. How can I get in touch?'),
                              content: const Text(
                                'Use the contact form to send a message to the configured Scup-Shop contact address.',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeIn(animate: !reduceMotion, 
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
