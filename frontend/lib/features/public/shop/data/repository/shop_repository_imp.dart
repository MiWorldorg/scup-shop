import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/shop/data/service/shop_service.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';

class ShopRepositoryImpl extends ShopRepository {
  final ShopService service;

  ShopRepositoryImpl({ShopService? service})
    : service = service ?? ShopService();

  @override
  Future<ApiPaginatedResult> getProducts(int page) => service.call(page);
}
