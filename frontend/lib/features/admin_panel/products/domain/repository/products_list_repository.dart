import '../../data/entity/products_list_response.dart';

abstract class ProductListRepository {
  Future<List<ProductListResponse>> getProductsList(int page);
  Future<List<ProductCategoryResponse>> getCategories();
  Future<void> createProduct(Map<String, dynamic> product);
  Future<void> updateProduct(int id, Map<String, dynamic> product);
  Future<void> deleteProduct(int id);
}
