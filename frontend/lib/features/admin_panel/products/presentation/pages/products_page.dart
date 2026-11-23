import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/widgets/async_state_view.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/entity/products_list_response.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/controllers/products_list_controller.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/pages/product_form_dialog.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/widgets/product_list_cards.dart';

class ProductListWidget extends GetView<ProductListController> {
  ProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 600 ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 12,
              children: [
                Text(
                  'Products',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => IconButton.filledTonal(
                        tooltip: 'Refresh products',
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.fetchLatestProduct,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => _showProductForm(context),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add product'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Review and manage items in your collection.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.68),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: controller.searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: controller.search,
              decoration: InputDecoration(
                hintText: 'Search products by name, description, or SKU',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  tooltip: 'Clear search',
                  onPressed: controller.clearSearch,
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => AsyncStateView(
                isLoading: controller.isLoading.value,
                errorMessage: controller.errorMessage.value,
                isEmpty: controller.products.isEmpty,
                emptyMessage: 'No products are available yet.',
                onRetry: controller.fetchLatestProduct,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: ProductListCard(
                        product: product,
                        onEdit: () => _showProductForm(context, product),
                        onDelete: () => _confirmDelete(context, product),
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

  Future<void> _showProductForm(
    BuildContext context, [
    ProductListResponse? product,
  ]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => ProductFormDialog(product: product),
    );
    if (saved == true) {
      Get.snackbar(
        product == null ? 'Product created' : 'Product updated',
        product == null
            ? 'The product is now in your collection.'
            : 'Your changes have been saved.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ProductListResponse product,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('Remove “${product.name}” from the collection?'),
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
      await controller.deleteProduct(product.id);
      Get.snackbar(
        'Product deleted',
        'The product has been removed from the collection.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Could not delete product',
        ApiResponse.userFacingError(error),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
