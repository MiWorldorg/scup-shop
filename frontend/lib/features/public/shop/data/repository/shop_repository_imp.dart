import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/shop_category_response.dart';
import 'package:sculpture_shop/features/public/shop/data/service/shop_service.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopService service;

  ShopRepositoryImpl({required this.service});

  @override
  Future<ApiPaginatedResult> getProducts(
    int page, {
    int? categoryId,
    String? search,
  }) => service.call(page, categoryId: categoryId, search: search);

  @override
  Future<List<ShopCategoryResponse>> getCategories() =>
      service.getCategories();
}
