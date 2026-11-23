import 'package:flutter/material.dart';
import 'package:sculpture_shop/core/formatters/price_formatter.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/entity/products_list_response.dart';

class ProductListCard extends StatelessWidget {
  final ProductListResponse product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductListCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.onSurface.withOpacity(0.08)),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 58,
              height: 58,
              color: colors.primary.withOpacity(0.08),
              child: product.image.isEmpty
                  ? Icon(Icons.inventory_2_outlined, color: colors.primary)
                  : Image.asset(
                      product.image,
                      fit: BoxFit.contain,
                      semanticLabel: product.name,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.inventory_2_outlined,
                        color: colors.primary,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 12,
                  runSpacing: 3,
                  children:
                      [
                            'SKU ${product.sku}',
                            if (product.categoryName.isNotEmpty)
                              product.categoryName,
                            'Stock ${product.quantity}',
                            '${PriceFormatter.amount(product.price)}',
                          ]
                          .map(
                            (label) => Text(
                              label,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colors.onSurface.withOpacity(0.62),
                                  ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            tooltip: 'Product actions',
            onSelected: (action) => action == 'edit' ? onEdit() : onDelete(),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 12),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 12),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
