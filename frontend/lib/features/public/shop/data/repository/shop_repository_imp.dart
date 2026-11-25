import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/shop/data/service/shop_service.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopService service;
  ShopRepositoryImpl({required this.service});

  @override
  Future<ApiPaginatedResult> getProducts(int page) => service.call(page);
}
