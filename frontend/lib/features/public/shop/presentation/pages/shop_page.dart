import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/async_state_view.dart';
import 'package:sculpture_shop/core/widgets/header.dart';
import 'package:sculpture_shop/core/widgets/sections_header.dart';
import 'package:sculpture_shop/core/widgets/website_drawer_mobile.dart';
import 'package:sculpture_shop/core/widgets/website_footer.dart';
import 'package:sculpture_shop/features/public/shop/presentation/controllers/shop_controller.dart';
import 'package:sculpture_shop/features/public/shop/presentation/pages/shop_product_tile.dart';
import 'package:sculpture_shop/features/public/shop/presentation/widgets/product_card_widget.dart';

class ShopPage extends GetView<ShopController> {
  ShopPage({super.key});

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
                Header(selectedIndex: 1.obs),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).cardColor,
                        colors.secondary.withOpacity(0.22),
                      ],
                    ),
                    border: Border.all(color: colors.primary.withOpacity(0.16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'THE COLLECTION',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sculptures with a story',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 620),
                        child: Text(
                          'Explore carefully selected pieces shaped by material, craft, and character.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: colors.onBackground.withOpacity(0.72),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller.searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: controller.search,
                  decoration: InputDecoration(
                    hintText: 'Search by name, description, or SKU',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      tooltip: 'Clear search and filters',
                      onPressed: controller.clearFilters,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  if (controller.categoriesLoading.value) {
                    return const LinearProgressIndicator();
                  }
                  if (controller.categoriesError.value != null) {
                    return Text(
                      'Category filters are temporarily unavailable.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                  if (controller.categories.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All pieces'),
                        selected: controller.selectedCategoryId.value == null,
                        onSelected: (_) => controller.selectCategory(null),
                      ),
                      ...controller.categories.map(
                        (category) => ChoiceChip(
                          label: Text(category.name),
                          selected: controller.selectedCategoryId.value ==
                              category.id,
                          onSelected: (_) =>
                              controller.selectCategory(category.id),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 24),
                const SectionsHeader(title: 'Shop the collection'),
                Obx(
                  () => AsyncStateView(
                    isLoading: controller.isLoading.value,
                    errorMessage: controller.errorMessage.value,
                    isEmpty: controller.products.isEmpty,
                    emptyMessage: 'New pieces will appear here soon.',
                    onRetry: controller.fetchLatestProduct,
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
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        final product = controller.products[index];
                        return ProductCart(
                          productModel: product,
                          page: ShopProductsTile(product: product),
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
