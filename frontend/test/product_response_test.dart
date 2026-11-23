import 'package:flutter_test/flutter_test.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/product_response.dart';

void main() {
  group('ProductResponse', () {
    test('parses product, category, inventory, and whole-dollar USD price', () {
      final product = ProductResponse.fromJson({
        'id': 42,
        'category_id': 7,
        'category': {'name': 'Sculptures'},
        'image': 'assets/images/products/marble-think.png',
        'name': 'Marble Thinker',
        'desc': 'A contemplative figure.',
        'sku': 'SC-THINK-001',
        'inventory_id': 3,
        'inventory': {'id': 3, 'quantity': 8},
        'price': 1250,
      });

      expect(product.productId, 42);
      expect(product.categoryName, 'Sculptures');
      expect(product.inventoryId, 3);
      expect(product.quantity, 8);
      expect(product.price, 1250);
    });

    test('handles missing, null, and malformed optional values', () {
      final product = ProductResponse.fromJson({
        'id': 'not-an-id',
        'category': null,
        'inventory': null,
        'price': null,
      });

      expect(product.productId, 0);
      expect(product.name, '');
      expect(product.categoryName, '');
      expect(product.inventoryId, 0);
      expect(product.quantity, 0);
      expect(product.price, 0);
    });
  });
}
