import 'package:sculpture_shop/features/public/shop/data/entity/product_response.dart';

abstract class ShopRepository {
  Future<List<ProductResponse>> getProducts(int page);
}