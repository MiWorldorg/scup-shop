import 'package:flutter/material.dart';
import 'package:sculpture_shop/core/formatters/price_formatter.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/constants/routes.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/header.dart';
import 'package:sculpture_shop/core/widgets/website_drawer_mobile.dart';
import 'package:sculpture_shop/core/widgets/website_footer.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/product_response.dart';

class ShopProductsTile extends StatelessWidget {
  final ProductResponse product;

  const ShopProductsTile({required this.product, super.key});

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
                  padding: const EdgeInsets.all(18),
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
                      final image = _productImage(context, isWide ? 460 : 280);
                      final details = _productDetails(context);
                      if (!isWide) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            image,
                            const SizedBox(height: 24),
                            details,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 6, child: image),
                          const SizedBox(width: 32),
                          Expanded(flex: 5, child: details),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: colors.onBackground.withOpacity(0.07),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About this piece',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onBackground.withOpacity(0.78),
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
    );
  }

  Widget _productImage(BuildContext context, double height) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.background.withOpacity(0.48),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Image.asset(
        product.image,
        fit: BoxFit.contain,
        semanticLabel: product.name,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported_outlined,
          size: 56,
          color: colors.onBackground.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _productDetails(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.categoryName.isNotEmpty
              ? product.categoryName.toUpperCase()
              : 'ARTWORK',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.primary,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 18),
        Text(
          'SKU  ${product.sku}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.onBackground.withOpacity(0.62),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Icon(
              product.quantity > 0
                  ? Icons.check_circle_outline_rounded
                  : Icons.remove_circle_outline_rounded,
              size: 18,
              color: product.quantity > 0 ? colors.tertiary : colors.error,
            ),
            const SizedBox(width: 8),
            Text(
              product.quantity > 0
                  ? 'In stock · ${product.quantity} available'
                  : 'Currently unavailable',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: product.quantity > 0 ? colors.tertiary : colors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          '${PriceFormatter.amount(product.price)} Toman',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.contactUs),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: const Text('Ask about this piece'),
          ),
        ),
      ],
    );
  }
}
