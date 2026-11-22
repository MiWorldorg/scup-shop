import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/widgets/async_state_view.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/entity/products_list_response.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/repository/products_list_repository_imp.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/controllers/products_list_controller.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/pages/product_form_dialog.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/widgets/product_list_cards.dart';

class ProductListWidget extends GetView<ProductListController> {
  @override
  final ProductListController controller = Get.put(
    ProductListController(repo: ProductListRepositoryImpl()),
  );

  ProductListWidget({super.key});

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
                    'Products',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
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
            const SizedBox(height: 6),
            Text(
              'Review and manage items in your collection.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.68),
              ),
            ),
            const SizedBox(height: 18),
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
