import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/entity/products_list_response.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/service/products_list_service.dart';
import 'package:sculpture_shop/features/admin_panel/products/domain/repository/products_list_repository.dart';

class ProductListRepositoryImpl implements ProductListRepository {
  final ProductListService service;
  ProductListRepositoryImpl({required this.service});

  @override
  Future<ApiPaginatedResult> getProductsList(int page, {String? search}) =>
      service.call(page, search: search);

  @override
  Future<List<ProductCategoryResponse>> getCategories() => service.getCategories();

  @override
  Future<void> createProduct(Map<String, dynamic> product) => service.createProduct(product);

  @override
  Future<void> updateProduct(int id, Map<String, dynamic> product) => service.updateProduct(id, product);

  @override
  Future<void> deleteProduct(int id) => service.deleteProduct(id);
}
