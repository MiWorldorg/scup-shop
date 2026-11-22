import 'package:flutter_test/flutter_test.dart';

import 'package:sculpture_shop/features/public/shop/data/entity/product_response.dart';

void main() {
  group('ProductResponse', () {
    test('fromJson reads product id, not category id', () {
      final json = {
        'id': 42,
        'category_id': 7,
        'category': {'name': 'Sculptures'},
        'image': 'assets/images/products/marble-think.png',
        'name': 'Marble Thinker',
        'desc': 'A contemplative figure.',
        'sku': 'SC-THINK-001',
        'inventory_id': 3,
        'price': 24500000,
      };

      final product = ProductResponse.fromJson(json);

      expect(product.productId, 42);
      expect(product.categoryName, 'Sculptures');
    });

    test('fromJson handles missing fields gracefully', () {
      final product = ProductResponse.fromJson({});

      expect(product.productId, 0);
      expect(product.name, '');
      expect(product.price, 0);
    });
  });
}
