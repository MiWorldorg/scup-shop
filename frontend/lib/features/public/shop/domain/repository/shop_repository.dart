import 'package:sculpture_shop/core/api/api_response.dart';

abstract class ShopRepository {
  Future<ApiPaginatedResult> getProducts(int page);
}
