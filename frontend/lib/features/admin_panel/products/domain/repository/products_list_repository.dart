import 'package:sculpture_shop/core/api/api_response.dart';
import '../../data/entity/products_list_response.dart';

abstract class ProductListRepository {
  Future<ApiPaginatedResult> getProductsList(int page, {String? search});
  Future<List<ProductCategoryResponse>> getCategories();
  Future<void> createProduct(Map<String, dynamic> product);
  Future<void> updateProduct(int id, Map<String, dynamic> product);
  Future<void> deleteProduct(int id);
}
