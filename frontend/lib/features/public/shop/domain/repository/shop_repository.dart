import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/shop_category_response.dart';

abstract class ShopRepository {
  Future<ApiPaginatedResult> getProducts(
    int page, {
    int? categoryId,
    String? search,
  });

  Future<List<ShopCategoryResponse>> getCategories();
}
